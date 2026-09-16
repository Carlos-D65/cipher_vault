import '../aes/aes_gcm_encryption_service.dart';
import '../chacha/chacha20_poly1305_encryption_service.dart';
import '../models/encryption_algorithm.dart';
import 'encryption_service.dart';

class EncryptionServiceFactory {
  final AesGcmEncryptionService aes;
  final Chacha20Poly1305EncryptionService chacha;

  EncryptionServiceFactory({
    AesGcmEncryptionService? aes,
    Chacha20Poly1305EncryptionService? chacha,
  })  : aes = aes ?? AesGcmEncryptionService(),
        chacha = chacha ?? Chacha20Poly1305EncryptionService();

  EncryptionService create(EncryptionAlgorithm algorithm) {
    switch (algorithm) {
      case EncryptionAlgorithm.aes256Gcm:
        return aes;

      case EncryptionAlgorithm.chacha20Poly1305:
        return chacha;
    }
  }
}