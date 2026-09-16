import '../models/kdf_parameters.dart';

abstract final class Argon2idParameters {
  static const KdfParameters current = KdfParameters(
    algorithm: 'argon2id',
    memory: 19456,
    iterations: 2,
    parallelism: 1,
    keyLength: 32,
  );
}