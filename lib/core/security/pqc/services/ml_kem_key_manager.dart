import '../models/ml_kem_algorithm.dart';
import '../models/ml_kem_key_pair.dart';
import '../storage/ml_kem_key_storage.dart';
import 'ml_kem_native_service.dart';

class MlKemKeyManager {
  final MlKemNativeService mlKemService;
  final MlKemKeyStorage storage;

  const MlKemKeyManager({
    this.mlKemService =
        const MlKemNativeService(),
    this.storage =
        const MlKemKeyStorage(),
  });

  Future<MlKemKeyPair> getOrCreateKeyPair({
    MlKemAlgorithm algorithm =
        MlKemAlgorithm.mlKem768,
  }) async {
    final existing =
        await storage.readKeyPair();

    if (existing != null) {
      if (existing.algorithm != algorithm) {
        throw StateError(
          'El dispositivo ya tiene una identidad ML-KEM '
          'con un algoritmo diferente.',
        );
      }

      return existing;
    }

    final generated =
        mlKemService.generateKeyPair(
      algorithm: algorithm,
    );

    await storage.writeKeyPair(generated);

    return generated;
  }

  Future<MlKemKeyPair> getExistingKeyPair() async {
    final existing =
        await storage.readKeyPair();

    if (existing == null) {
      throw StateError(
        'No existe una identidad ML-KEM en este dispositivo.',
      );
    }

    return existing;
  }
}