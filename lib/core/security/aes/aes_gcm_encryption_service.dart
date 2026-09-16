import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import '../codec/cipher_vault_aad.dart';
import '../models/escrypted_data.dart';
import '../models/encryption_algorithm.dart';
import '../kdf/argon2od_parameters.dart';
import '../kdf/argon2id_key_derivation_service.dart';
import '../random/secure_random_bytes.dart';
import '../services/encryption_service.dart';

class AesGcmEncryptionService implements EncryptionService {
  static const int _version = 1;
  static const int _saltLength = 16;

  final AesGcm _algorithm;
  final Argon2idKeyDerivationService _keyDerivation;

  AesGcmEncryptionService({
    AesGcm? algorithm,
    Argon2idKeyDerivationService? keyDerivation,
  })  : _algorithm = algorithm ?? AesGcm.with256bits(),
        _keyDerivation =
            keyDerivation ?? const Argon2idKeyDerivationService();

  @override
  Future<EncryptedData> encrypt({
    required String plaintext,
    required String password,
  }) async {
    if (password.isEmpty) {
      throw ArgumentError('La contraseña no puede estar vacía.');
    }

    final salt = SecureRandomBytes.bytes(_saltLength);

    final parameters = Argon2idParameters.current;

    final keyBytes = await _keyDerivation.deriveKey(
      password: password,
      salt: salt,
      parameters: parameters,
    );

    final secretKey = SecretKey(keyBytes);

    final nonce = _algorithm.newNonce();

    final metadata = EncryptedData(
      version: _version,
      algorithm: EncryptionAlgorithm.aes256Gcm,
      kdf: parameters.algorithm,
      kdfParameters: parameters,
      salt: salt,
      nonce: nonce,
      ciphertext: const [],
      authenticationTag: const [],
    );

    final aad = CipherVaultAad.build(metadata);

    final secretBox = await _algorithm.encrypt(
      utf8.encode(plaintext),
      secretKey: secretKey,
      nonce: nonce,
      aad: aad,
    );

    return EncryptedData(
      version: _version,
      algorithm: EncryptionAlgorithm.aes256Gcm,
      kdf: parameters.algorithm,
      kdfParameters: parameters,
      salt: salt,
      nonce: secretBox.nonce,
      ciphertext: secretBox.cipherText,
      authenticationTag: secretBox.mac.bytes,
    );
  }

  @override
  Future<String> decrypt({
    required EncryptedData encryptedData,
    required String password,
  }) async {
    if (encryptedData.algorithm !=
        EncryptionAlgorithm.aes256Gcm) {
      throw ArgumentError(
        'El payload no corresponde a AES-256-GCM.',
      );
    }

    if (password.isEmpty) {
      throw ArgumentError('La contraseña no puede estar vacía.');
    }

    final keyBytes = await _keyDerivation.deriveKey(
      password: password,
      salt: encryptedData.salt,
      parameters: encryptedData.kdfParameters,
    );

    final secretKey = SecretKey(keyBytes);

    final aad = CipherVaultAad.build(encryptedData);

    final secretBox = SecretBox(
      encryptedData.ciphertext,
      nonce: encryptedData.nonce,
      mac: Mac(encryptedData.authenticationTag),
    );

    final clearBytes = await _algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
      aad: aad,
    );

    return utf8.decode(clearBytes);
  }
}