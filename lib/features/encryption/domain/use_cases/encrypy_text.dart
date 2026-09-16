import '../../../../core/security/models/escrypted_data.dart';
import '../../../../core/security/models/encryption_algorithm.dart';
import '../repositories/encryption_repository.dart';

class EncryptText {
  final EncryptionRepository repository;

  const EncryptText(this.repository);

  Future<EncryptedData> call({
    required String plaintext,
    required String password,
    required EncryptionAlgorithm algorithm,
  }) {
    return repository.encrypt(
      plaintext: plaintext,
      password: password,
      algorithm: algorithm,
    );
  }
}
