import '../../../../core/security/models/escrypted_data.dart';
import '../../../../core/security/models/encryption_algorithm.dart';

abstract interface class EncryptionRepository {
  Future<EncryptedData> encrypt({
    required String plaintext,
    required String password,
    required EncryptionAlgorithm algorithm,
  });

  Future<String> decrypt({
    required EncryptedData encryptedData,
    required String password,
  });
}
