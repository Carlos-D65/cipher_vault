import '../../../../core/security/models/escrypted_data.dart';
import '../../../../core/security/models/encryption_algorithm.dart';
import '../../../../core/security/services/encryption_service_factory.dart';
import '../../domain/repositories/encryption_repository.dart';

class EncryptionRepositoryImpl implements EncryptionRepository {
  final EncryptionServiceFactory factory;

  EncryptionRepositoryImpl({EncryptionServiceFactory? factory})
    : factory = factory ?? EncryptionServiceFactory();

  @override
  Future<EncryptedData> encrypt({
    required String plaintext,
    required String password,
    required EncryptionAlgorithm algorithm,
  }) {
    final service = factory.create(algorithm);

    return service.encrypt(plaintext: plaintext, password: password);
  }

  @override
  Future<String> decrypt({
    required EncryptedData encryptedData,
    required String password,
  }) {
    final service = factory.create(encryptedData.algorithm);

    return service.decrypt(encryptedData: encryptedData, password: password);
  }
}
