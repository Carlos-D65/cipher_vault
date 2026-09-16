import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import '../../random/secure_random_bytes.dart';
import '../../pqc/models/ml_kem_algorithm.dart';
import '../../pqc/services/hybrid_key_derivation_service.dart';
import '../../pqc/services/ml_kem_key_manager.dart';
import '../codec/advanced_cipher_vault_aad.dart';
import '../models/advanced_encrypted_data.dart';
import 'advanced_encryption_service.dart';

class Chacha20MlKemEncryptionService
    implements AdvancedEncryptionService {
  static const int _version = 2;
  static const int _saltLength = 16;
  static const int _nonceLength = 12;
  static const String _algorithmId =
      'chacha20-poly1305';

  final Chacha20 _chacha;
  final MlKemKeyManager _keyManager;
  final HybridKeyDerivationService _hybridKdf;

  Chacha20MlKemEncryptionService({
    Chacha20? chacha,
    MlKemKeyManager? keyManager,
    HybridKeyDerivationService? hybridKdf,
  })  : _chacha =
            chacha ?? Chacha20.poly1305Aead(),
        _keyManager = keyManager ?? MlKemKeyManager(),
        _hybridKdf =
            hybridKdf ?? const HybridKeyDerivationService();

  @override
  Future<AdvancedEncryptedData> encrypt({
    required String plaintext,
    required String password,
  }) async {
    _validateInput(
      plaintext: plaintext,
      password: password,
    );

    final keyPair =
        await _keyManager.getOrCreateKeyPair(
      algorithm: MlKemAlgorithm.mlKem768,
    );

    final encapsulation =
        _keyManager.mlKemService.encapsulate(
      algorithm: MlKemAlgorithm.mlKem768,
      publicKey: keyPair.publicKey,
    );

    final salt =
        SecureRandomBytes.bytes(_saltLength);

    final encryptionKey =
        await _hybridKdf.deriveEncryptionKey(
      password: password,
      salt: salt,
      mlKemSharedSecret:
          encapsulation.sharedSecret,
      mlKemAlgorithm:
          MlKemAlgorithm.mlKem768,
    );

    final nonce = _chacha.newNonce();

    final temporaryData =
        AdvancedEncryptedData(
      version: _version,
      symmetricAlgorithm: _algorithmId,
      mlKemAlgorithm:
          MlKemAlgorithm.mlKem768,
      salt: salt,
      kemCiphertext:
          encapsulation.ciphertext,
      nonce: nonce,
      ciphertext: const <int>[],
      authenticationTag:
          const <int>[],
    );

    final aad =
        AdvancedCipherVaultAad.build(
      temporaryData,
    );

    final secretBox =
        await _chacha.encrypt(
      utf8.encode(plaintext),
      secretKey:
          SecretKey(encryptionKey),
      nonce: nonce,
      aad: aad,
    );

    return AdvancedEncryptedData(
      version: _version,
      symmetricAlgorithm: _algorithmId,
      mlKemAlgorithm:
          MlKemAlgorithm.mlKem768,
      salt: salt,
      kemCiphertext:
          encapsulation.ciphertext,
      nonce: secretBox.nonce,
      ciphertext:
          secretBox.cipherText,
      authenticationTag:
          secretBox.mac.bytes,
    );
  }

  @override
  Future<String> decrypt({
    required AdvancedEncryptedData encryptedData,
    required String password,
  }) async {
    if (password.isEmpty) {
      throw ArgumentError(
        'La contraseña no puede estar vacía.',
      );
    }

    _validateEncryptedData(
      encryptedData,
    );

    final keyPair =
        await _keyManager.getExistingKeyPair();

    if (keyPair.algorithm !=
        encryptedData.mlKemAlgorithm) {
      throw StateError(
        'La identidad ML-KEM del dispositivo '
        'no coincide con la utilizada para este payload.',
      );
    }

    final sharedSecret =
        _keyManager.mlKemService.decapsulate(
      algorithm:
          encryptedData.mlKemAlgorithm,
      ciphertext:
          encryptedData.kemCiphertext,
      secretKey:
          keyPair.secretKey,
    );

    final encryptionKey =
        await _hybridKdf.deriveEncryptionKey(
      password: password,
      salt: encryptedData.salt,
      mlKemSharedSecret:
          sharedSecret,
      mlKemAlgorithm:
          encryptedData.mlKemAlgorithm,
    );

    final aad =
        AdvancedCipherVaultAad.build(
      encryptedData,
    );

    final secretBox = SecretBox(
      encryptedData.ciphertext,
      nonce: encryptedData.nonce,
      mac: Mac(
        encryptedData.authenticationTag,
      ),
    );

    final clearBytes =
        await _chacha.decrypt(
      secretBox,
      secretKey:
          SecretKey(encryptionKey),
      aad: aad,
    );

    return utf8.decode(
      clearBytes,
      allowMalformed: false,
    );
  }

  void _validateInput({
    required String plaintext,
    required String password,
  }) {
    if (plaintext.isEmpty) {
      throw ArgumentError(
        'El mensaje no puede estar vacío.',
      );
    }

    if (password.isEmpty) {
      throw ArgumentError(
        'La contraseña no puede estar vacía.',
      );
    }
  }

  void _validateEncryptedData(
    AdvancedEncryptedData data,
  ) {
    if (data.version != _version) {
      throw FormatException(
        'Versión CVLT2 no soportada: ${data.version}.',
      );
    }

    if (data.symmetricAlgorithm !=
        _algorithmId) {
      throw FormatException(
        'El payload no pertenece a ChaCha20-Poly1305.',
      );
    }

    if (data.salt.length !=
        _saltLength) {
      throw FormatException(
        'Salt inválido.',
      );
    }

    if (data.nonce.length !=
        _nonceLength) {
      throw FormatException(
        'Nonce ChaCha20 inválido.',
      );
    }

    if (data.authenticationTag.length !=
        16) {
      throw FormatException(
        'Authentication tag inválido.',
      );
    }

    if (data.kemCiphertext.isEmpty) {
      throw FormatException(
        'Ciphertext ML-KEM vacío.',
      );
    }

    if (data.ciphertext.isEmpty) {
      throw FormatException(
        'Ciphertext ChaCha20 vacío.',
      );
    }
  }
}