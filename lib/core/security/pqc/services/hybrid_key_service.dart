import 'dart:typed_data';

import '../models/hybrid_key_material.dart';
import '../models/ml_kem_algorithm.dart';
import 'hybrid_key_derivation_service.dart';
import 'ml_kem_service.dart';

class HybridKeyService {
  final MlKemService mlKemService;
  final HybridKeyDerivationService keyDerivationService;

  const HybridKeyService({
    required this.mlKemService,
    required this.keyDerivationService,
  });

  HybridKeyMaterial createKeyMaterial({
    required MlKemAlgorithm algorithm,
    required List<int> publicKey,
  }) {
    final encapsulation =
        mlKemService.encapsulate(
      algorithm: algorithm,
      publicKey: publicKey,
    );

    return HybridKeyMaterial(
      mlKemAlgorithm: algorithm,
      sharedSecret: Uint8List.fromList(
        encapsulation.sharedSecret,
      ),
    );
  }

  Future<Uint8List> deriveEncryptionKey({
    required String password,
    required HybridKeyMaterial keyMaterial,
    required List<int> salt,
  }) {
    return keyDerivationService
        .deriveEncryptionKey(
      password: password,
      salt: salt,
      mlKemSharedSecret:
          keyMaterial.sharedSecret,
      mlKemAlgorithm:
          keyMaterial.mlKemAlgorithm,
    );
  }

  Uint8List recoverSharedSecret({
    required MlKemAlgorithm algorithm,
    required List<int> ciphertext,
    required List<int> secretKey,
  }) {
    return Uint8List.fromList(
      mlKemService.decapsulate(
        algorithm: algorithm,
        ciphertext: ciphertext,
        secretKey: secretKey,
      ),
    );
  }
}