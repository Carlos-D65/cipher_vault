import '../models/ml_kem_algorithm.dart';
import '../models/ml_kem_encapsulation.dart';
import '../models/ml_kem_key_pair.dart';

abstract interface class MlKemService {
  MlKemKeyPair generateKeyPair({
    required MlKemAlgorithm algorithm,
  });

  MlKemEncapsulation encapsulate({
    required MlKemAlgorithm algorithm,
    required List<int> publicKey,
  });

  List<int> decapsulate({
    required MlKemAlgorithm algorithm,
    required List<int> ciphertext,
    required List<int> secretKey,
  });
}