import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import '../models/ml_kem_algorithm.dart';

class HybridKeyDerivationService {
  static const int keyLength = 32;

  static const int _saltLength = 16;
  static const int _argon2Memory = 19456;
  static const int _argon2Iterations = 2;
  static const int _argon2Parallelism = 1;

  static const String _context =
      'CipherVault-CVLT2-Hybrid-AEAD-v1';

  const HybridKeyDerivationService();

  Future<Uint8List> deriveEncryptionKey({
    required String password,
    required List<int> salt,
    required List<int> mlKemSharedSecret,
    required MlKemAlgorithm mlKemAlgorithm,
  }) async {
    if (password.isEmpty) {
      throw ArgumentError(
        'La contraseña no puede estar vacía.',
      );
    }

    if (salt.length != _saltLength) {
      throw ArgumentError(
        'El salt debe tener exactamente $_saltLength bytes.',
      );
    }

    if (mlKemSharedSecret.length != 32) {
      throw ArgumentError(
        'El secreto compartido de ML-KEM debe tener 32 bytes.',
      );
    }

    final argon2id = Argon2id(
      memory: _argon2Memory,
      iterations: _argon2Iterations,
      parallelism: _argon2Parallelism,
      hashLength: 32,
    );

    final passwordSecret =
        await argon2id.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );

    final passwordBytes =
        await passwordSecret.extractBytes();

    final hybridSecret = Uint8List.fromList([
      ...passwordBytes,
      ...mlKemSharedSecret,
    ]);

    final hkdf = Hkdf(
      hmac: Hmac.sha256(),
      outputLength: keyLength,
    );

    final info = utf8.encode(
      '$_context:${mlKemAlgorithm.id}',
    );

    final derivedKey = await hkdf.deriveKey(
      secretKey: SecretKey(hybridSecret),
      nonce: salt,
      info: info,
    );

    final keyBytes =
        await derivedKey.extractBytes();

    if (keyBytes.length != keyLength) {
      throw StateError(
        'HKDF produjo una clave de longitud inválida.',
      );
    }

    return Uint8List.fromList(keyBytes);
  }
}