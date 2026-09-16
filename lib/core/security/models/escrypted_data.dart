import 'encryption_algorithm.dart';
import 'kdf_parameters.dart';

class EncryptedData {
  final int version;
  final EncryptionAlgorithm algorithm;
  final String kdf;
  final KdfParameters kdfParameters;
  final List<int> salt;
  final List<int> nonce;
  final List<int> ciphertext;
  final List<int> authenticationTag;

  const EncryptedData({
    required this.version,
    required this.algorithm,
    required this.kdf,
    required this.kdfParameters,
    required this.salt,
    required this.nonce,
    required this.ciphertext,
    required this.authenticationTag,
  });

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'algorithm': algorithm.id,
      'kdf': kdf,
      'kdfParameters': kdfParameters.toJson(),
      'salt': salt,
      'nonce': nonce,
      'ciphertext': ciphertext,
      'authenticationTag': authenticationTag,
    };
  }

  factory EncryptedData.fromJson(Map<String, dynamic> json) {
    return EncryptedData(
      version: json['version'] as int,
      algorithm: EncryptionAlgorithm.fromId(
        json['algorithm'] as String,
      ),
      kdf: json['kdf'] as String,
      kdfParameters: KdfParameters.fromJson(
        Map<String, dynamic>.from(
          json['kdfParameters'] as Map,
        ),
      ),
      salt: List<int>.from(json['salt'] as List),
      nonce: List<int>.from(json['nonce'] as List),
      ciphertext: List<int>.from(json['ciphertext'] as List),
      authenticationTag: List<int>.from(
        json['authenticationTag'] as List,
      ),
    );
  }
}