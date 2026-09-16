import '../models/advanced_encrypted_data.dart';

abstract interface class AdvancedEncryptionService {
  Future<AdvancedEncryptedData> encrypt({
    required String plaintext,
    required String password,
  });

  Future<String> decrypt({
    required AdvancedEncryptedData encryptedData,
    required String password,
  });
}