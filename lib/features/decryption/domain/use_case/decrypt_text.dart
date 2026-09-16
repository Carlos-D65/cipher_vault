import '../../../../core/security/models/escrypted_data.dart';
import '../repositories/decryption_repository.dart';

class DecryptText {
  final DecryptionRepository repository;

  const DecryptText(this.repository);

  Future<String> call({
    required EncryptedData encryptedData,
    required String password,
  }) {
    return repository.decrypt(
      encryptedData: encryptedData,
      password: password,
    );
  }
}