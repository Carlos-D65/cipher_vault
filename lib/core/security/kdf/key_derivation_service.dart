import '../models/kdf_parameters.dart';

abstract interface class KeyDerivationService {
  Future<List<int>> deriveKey({
    required String password,
    required List<int> salt,
    required KdfParameters parameters,
  });
}