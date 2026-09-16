import 'package:cryptography/cryptography.dart';

import '../models/kdf_parameters.dart';
import 'key_derivation_service.dart';

class Argon2idKeyDerivationService
    implements KeyDerivationService {
  const Argon2idKeyDerivationService();

  @override
  Future<List<int>> deriveKey({
    required String password,
    required List<int> salt,
    required KdfParameters parameters,
  }) async {
    if (parameters.algorithm != 'argon2id') {
      throw ArgumentError(
        'KDF no soportado: ${parameters.algorithm}',
      );
    }

    final algorithm = Argon2id(
      memory: parameters.memory,
      iterations: parameters.iterations,
      parallelism: parameters.parallelism,
      hashLength: parameters.keyLength,
    );

    final secretKey = await algorithm.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );

    return secretKey.extractBytes();
  }
}