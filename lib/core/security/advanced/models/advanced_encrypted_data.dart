import 'dart:typed_data';

import '../../pqc/models/ml_kem_algorithm.dart';

class AdvancedEncryptedData {
  final int version;
  final String symmetricAlgorithm;
  final MlKemAlgorithm mlKemAlgorithm;

  final List<int> salt;
  final List<int> kemCiphertext;
  final List<int> nonce;
  final List<int> ciphertext;
  final List<int> authenticationTag;

  const AdvancedEncryptedData({
    required this.version,
    required this.symmetricAlgorithm,
    required this.mlKemAlgorithm,
    required this.salt,
    required this.kemCiphertext,
    required this.nonce,
    required this.ciphertext,
    required this.authenticationTag,
  });

  Uint8List get saltBytes =>
      Uint8List.fromList(salt);

  Uint8List get kemCiphertextBytes =>
      Uint8List.fromList(kemCiphertext);

  Uint8List get nonceBytes =>
      Uint8List.fromList(nonce);

  Uint8List get ciphertextBytes =>
      Uint8List.fromList(ciphertext);

  Uint8List get authenticationTagBytes =>
      Uint8List.fromList(authenticationTag);

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'symmetricAlgorithm':
          symmetricAlgorithm,
      'mlKemAlgorithm':
          mlKemAlgorithm.id,
      'salt': salt,
      'kemCiphertext':
          kemCiphertext,
      'nonce': nonce,
      'ciphertext':
          ciphertext,
      'authenticationTag':
          authenticationTag,
    };
  }

  factory AdvancedEncryptedData.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdvancedEncryptedData(
      version: json['version'] as int,
      symmetricAlgorithm:
          json['symmetricAlgorithm'] as String,
      mlKemAlgorithm:
          MlKemAlgorithm.fromId(
        json['mlKemAlgorithm'] as String,
      ),
      salt: List<int>.from(
        json['salt'] as List,
      ),
      kemCiphertext:
          List<int>.from(
        json['kemCiphertext'] as List,
      ),
      nonce: List<int>.from(
        json['nonce'] as List,
      ),
      ciphertext:
          List<int>.from(
        json['ciphertext'] as List,
      ),
      authenticationTag:
          List<int>.from(
        json['authenticationTag'] as List,
      ),
    );
  }
}