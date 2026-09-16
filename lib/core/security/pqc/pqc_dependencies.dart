import 'services/hybrid_key_derivation_service.dart';
import 'services/hybrid_key_service.dart';
import 'services/ml_kem_native_service.dart';

abstract final class PqcDependencies {
  static HybridKeyService createHybridKeyService() {
    const mlKemService = MlKemNativeService();
    const keyDerivationService =
        HybridKeyDerivationService();

    return HybridKeyService(
      mlKemService: mlKemService,
      keyDerivationService: keyDerivationService,
    );
  }
}