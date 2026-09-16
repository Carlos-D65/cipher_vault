import 'dart:typed_data';

import 'package:mlkem_native/mlkem512.dart';
import 'package:mlkem_native/mlkem768.dart';
import 'package:mlkem_native/mlkem1024.dart';

import '../models/ml_kem_algorithm.dart';
import '../models/ml_kem_encapsulation.dart';
import '../models/ml_kem_key_pair.dart';
import 'ml_kem_service.dart';

class MlKemNativeService implements MlKemService {
  const MlKemNativeService();

  @override
  MlKemKeyPair generateKeyPair({
    required MlKemAlgorithm algorithm,
  }) {
    switch (algorithm) {
      case MlKemAlgorithm.mlKem512:
        final kem = MLKEM512();
        final keyPair = kem.generateKeyPair();

        return MlKemKeyPair(
          algorithm: algorithm,
          publicKey: Uint8List.fromList(
            keyPair.publicKey,
          ),
          secretKey: Uint8List.fromList(
            keyPair.secretKey,
          ),
        );

      case MlKemAlgorithm.mlKem768:
        final kem = MLKEM768();
        final keyPair = kem.generateKeyPair();

        return MlKemKeyPair(
          algorithm: algorithm,
          publicKey: Uint8List.fromList(
            keyPair.publicKey,
          ),
          secretKey: Uint8List.fromList(
            keyPair.secretKey,
          ),
        );

      case MlKemAlgorithm.mlKem1024:
        final kem = MLKEM1024();
        final keyPair = kem.generateKeyPair();

        return MlKemKeyPair(
          algorithm: algorithm,
          publicKey: Uint8List.fromList(
            keyPair.publicKey,
          ),
          secretKey: Uint8List.fromList(
            keyPair.secretKey,
          ),
        );
    }
  }

  @override
  MlKemEncapsulation encapsulate({
    required MlKemAlgorithm algorithm,
    required List<int> publicKey,
  }) {
    switch (algorithm) {
      case MlKemAlgorithm.mlKem512:
        final kem = MLKEM512();

        final result = kem.encapsulate(
          Uint8List.fromList(publicKey),
        );

        return MlKemEncapsulation(
          algorithm: algorithm,
          ciphertext: Uint8List.fromList(
            result.ciphertext,
          ),
          sharedSecret: Uint8List.fromList(
            result.sharedSecret,
          ),
        );

      case MlKemAlgorithm.mlKem768:
        final kem = MLKEM768();

        final result = kem.encapsulate(
          Uint8List.fromList(publicKey),
        );

        return MlKemEncapsulation(
          algorithm: algorithm,
          ciphertext: Uint8List.fromList(
            result.ciphertext,
          ),
          sharedSecret: Uint8List.fromList(
            result.sharedSecret,
          ),
        );

      case MlKemAlgorithm.mlKem1024:
        final kem = MLKEM1024();

        final result = kem.encapsulate(
          Uint8List.fromList(publicKey),
        );

        return MlKemEncapsulation(
          algorithm: algorithm,
          ciphertext: Uint8List.fromList(
            result.ciphertext,
          ),
          sharedSecret: Uint8List.fromList(
            result.sharedSecret,
          ),
        );
    }
  }

  @override
  List<int> decapsulate({
    required MlKemAlgorithm algorithm,
    required List<int> ciphertext,
    required List<int> secretKey,
  }) {
    switch (algorithm) {
      case MlKemAlgorithm.mlKem512:
        final kem = MLKEM512();

        return kem.decapsulate(
          Uint8List.fromList(ciphertext),
          Uint8List.fromList(secretKey),
        );

      case MlKemAlgorithm.mlKem768:
        final kem = MLKEM768();

        return kem.decapsulate(
          Uint8List.fromList(ciphertext),
          Uint8List.fromList(secretKey),
        );

      case MlKemAlgorithm.mlKem1024:
        final kem = MLKEM1024();

        return kem.decapsulate(
          Uint8List.fromList(ciphertext),
          Uint8List.fromList(secretKey),
        );
    }
  }
}