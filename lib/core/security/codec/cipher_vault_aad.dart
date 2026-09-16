import 'dart:convert';

import '../models/escrypted_data.dart';


abstract final class CipherVaultAad {
  static List<int> build(EncryptedData data) {
    final metadata = <String, dynamic>{
      'version': data.version,
      'algorithm': data.algorithm.id,
      'kdf': data.kdf,
      'kdfParameters': {
        'algorithm': data.kdfParameters.algorithm,
        'memory': data.kdfParameters.memory,
        'iterations': data.kdfParameters.iterations,
        'parallelism': data.kdfParameters.parallelism,
        'keyLength': data.kdfParameters.keyLength,
      },
    };

    return utf8.encode(jsonEncode(metadata));
  }
}