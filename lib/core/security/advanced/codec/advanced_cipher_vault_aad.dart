import 'dart:convert';

import '../models/advanced_encrypted_data.dart';

abstract final class AdvancedCipherVaultAad {
  static List<int> build(
    AdvancedEncryptedData data,
  ) {
    final metadata = <String, dynamic>{
      'version': data.version,
      'symmetricAlgorithm':
          data.symmetricAlgorithm,
      'mlKemAlgorithm':
          data.mlKemAlgorithm.id,
      'salt': data.salt,
      'kemCiphertext':
          data.kemCiphertext,
    };

    return utf8.encode(
      jsonEncode(metadata),
    );
  }
}