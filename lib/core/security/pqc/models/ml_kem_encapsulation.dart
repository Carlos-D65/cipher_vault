import 'dart:typed_data';

import 'ml_kem_algorithm.dart';

class MlKemEncapsulation {
  final MlKemAlgorithm algorithm;
  final Uint8List ciphertext;
  final Uint8List sharedSecret;

  const MlKemEncapsulation({
    required this.algorithm,
    required this.ciphertext,
    required this.sharedSecret,
  });
}