import '../models/escrypted_data.dart';

abstract interface class EncryptionService {
  Future<EncryptedData> encrypt({
    required String plaintext,
    required String password,
  });

  Future<String> decrypt({
    required EncryptedData encryptedData,
    required String password,
  });
}