import 'dart:convert';

import '../models/escrypted_data.dart';
import '../models/encryption_algorithm.dart';
import '../models/kdf_parameters.dart';

abstract final class CipherVaultPayloadCodec {
  static const String _prefix = 'CVLT';
  static const int _currentVersion = 1;

  static String encode(EncryptedData data) {
    if (data.version != _currentVersion) {
      throw FormatException(
        'Versión de payload no soportada: ${data.version}',
      );
    }

    final json = <String, dynamic>{
      'version': data.version,
      'algorithm': data.algorithm.id,
      'kdf': data.kdf,
      'kdfParameters': data.kdfParameters.toJson(),
      'salt': base64UrlEncode(data.salt),
      'nonce': base64UrlEncode(data.nonce),
      'ciphertext': base64UrlEncode(data.ciphertext),
      'authenticationTag': base64UrlEncode(data.authenticationTag),
    };

    final jsonBytes = utf8.encode(jsonEncode(json));
    final payload = base64UrlEncode(jsonBytes);

    return '$_prefix$_currentVersion.$payload';
  }

  static EncryptedData decode(String payload) {
    final value = payload.trim();

    if (value.isEmpty) {
      throw const FormatException(
        'El payload está vacío.',
      );
    }

    final prefix = '$_prefix$_currentVersion.';

    if (!value.startsWith(prefix)) {
      throw const FormatException(
        'El payload de CipherVault no es válido.',
      );
    }

    final encodedJson = value.substring(prefix.length);

    if (encodedJson.isEmpty) {
      throw const FormatException(
        'El payload no contiene datos.',
      );
    }

    try {
      final jsonBytes = base64Url.decode(encodedJson);
      final jsonString = utf8.decode(jsonBytes);

      final decoded = jsonDecode(jsonString);

      if (decoded is! Map) {
        throw const FormatException(
          'La estructura del payload no es válida.',
        );
      }

      final map = Map<String, dynamic>.from(decoded);

      final version = map['version'];

      if (version != _currentVersion) {
        throw FormatException(
          'Versión no soportada: $version',
        );
      }

      final salt = _decodeBytes(
        map['salt'],
        field: 'salt',
      );

      final nonce = _decodeBytes(
        map['nonce'],
        field: 'nonce',
      );

      final ciphertext = _decodeBytes(
        map['ciphertext'],
        field: 'ciphertext',
      );

      final authenticationTag = _decodeBytes(
        map['authenticationTag'],
        field: 'authenticationTag',
      );

      final kdfParametersRaw = map['kdfParameters'];

      if (kdfParametersRaw is! Map) {
        throw const FormatException(
          'Los parámetros del KDF no son válidos.',
        );
      }

      return EncryptedData(
        version: version as int,
        algorithm: EncryptionAlgorithm.fromId(
          map['algorithm'] as String,
        ),
        kdf: map['kdf'] as String,
        kdfParameters: KdfParameters.fromJson(
          Map<String, dynamic>.from(kdfParametersRaw),
        ),
        salt: salt,
        nonce: nonce,
        ciphertext: ciphertext,
        authenticationTag: authenticationTag,
      );
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException(
        'No fue posible leer el payload de CipherVault.',
      );
    }
  }

  static List<int> _decodeBytes(
    dynamic value, {
    required String field,
  }) {
    if (value is! String || value.isEmpty) {
      throw FormatException(
        'El campo $field no es válido.',
      );
    }

    try {
      return base64Url.decode(value);
    } catch (_) {
      throw FormatException(
        'El campo $field contiene datos inválidos.',
      );
    }
  }
}