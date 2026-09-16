import '../../../../core/security/models/escrypted_data.dart';

abstract interface class DecryptionRepository {
  Future<String> decrypt({
    required EncryptedData encryptedData,
    required String password,
  });
}