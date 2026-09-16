import 'dart:typed_data';

import 'ml_kem_algorithm.dart';

class HybridKeyMaterial {
  final MlKemAlgorithm mlKemAlgorithm;
  final Uint8List sharedSecret;

  const HybridKeyMaterial({
    required this.mlKemAlgorithm,
    required this.sharedSecret,
  });
}