import '../../../../core/security/models/escrypted_data.dart';
import '../../../../core/security/services/encryption_service_factory.dart';
import '../../domain/repositories/decryption_repository.dart';

class DecryptionRepositoryImpl
    implements DecryptionRepository {
  final EncryptionServiceFactory factory;

  DecryptionRepositoryImpl({
    EncryptionServiceFactory? factory,
  }) : factory = factory ?? EncryptionServiceFactory();

  @override
  Future<String> decrypt({
    required EncryptedData encryptedData,
    required String password,
  }) {
    final service = factory.create(
      encryptedData.algorithm,
    );

    return service.decrypt(
      encryptedData: encryptedData,
      password: password,
    );
  }
}