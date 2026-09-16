import 'dart:typed_data';

import 'ml_kem_algorithm.dart';

class MlKemKeyPair {
  final MlKemAlgorithm algorithm;
  final Uint8List publicKey;
  final Uint8List secretKey;

  const MlKemKeyPair({
    required this.algorithm,
    required this.publicKey,
    required this.secretKey,
  });
}