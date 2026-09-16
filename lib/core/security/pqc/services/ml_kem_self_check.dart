import 'dart:typed_data';

import '../models/ml_kem_algorithm.dart';
import 'hybrid_key_derivation_service.dart';
import 'ml_kem_native_service.dart';

abstract final class MlKemSelfCheck {
  static Future<bool> run() async {
    const mlKemService = MlKemNativeService();
    const keyDerivationService =
        HybridKeyDerivationService();

    const algorithm = MlKemAlgorithm.mlKem768;

    final keyPair = mlKemService.generateKeyPair(
      algorithm: algorithm,
    );

    final encapsulated = mlKemService.encapsulate(
      algorithm: algorithm,
      publicKey: keyPair.publicKey,
    );

    final recoveredSecret =
        mlKemService.decapsulate(
      algorithm: algorithm,
      ciphertext: encapsulated.ciphertext,
      secretKey: keyPair.secretKey,
    );

    if (encapsulated.sharedSecret.length != 32) {
      return false;
    }

    if (recoveredSecret.length != 32) {
      return false;
    }

    for (var i = 0;
        i < recoveredSecret.length;
        i++) {
      if (encapsulated.sharedSecret[i] !=
          recoveredSecret[i]) {
        return false;
      }
    }

    final salt = Uint8List.fromList(
      List<int>.generate(
        16,
        (index) => index,
      ),
    );

    final hybridKey =
        await keyDerivationService
            .deriveEncryptionKey(
      password:
          'CipherVault-self-check-password',
      salt: salt,
      mlKemSharedSecret:
          recoveredSecret,
      mlKemAlgorithm: algorithm,
    );

    return hybridKey.length == 32;
  }
}