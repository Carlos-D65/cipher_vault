import 'dart:convert';

import '../models/advanced_encrypted_data.dart';

abstract final class AdvancedCipherVaultPayloadCodec {
  static const String _prefix = 'CVLT2.';

  static String encode(
    AdvancedEncryptedData data,
  ) {
    final json = jsonEncode(data.toJson());

    final encoded = base64UrlEncode(
      utf8.encode(json),
    );

    return '$_prefix$encoded';
  }

  static AdvancedEncryptedData decode(
    String payload,
  ) {
    if (!payload.startsWith(_prefix)) {
      throw const FormatException(
        'El payload no tiene formato CVLT2.',
      );
    }

    final encoded =
        payload.substring(_prefix.length);

    if (encoded.isEmpty) {
      throw const FormatException(
        'El payload CVLT2 está vacío.',
      );
    }

    try {
      final jsonBytes =
          base64Url.decode(encoded);

      final jsonString =
          utf8.decode(
        jsonBytes,
        allowMalformed: false,
      );

      final decoded =
          jsonDecode(jsonString);

      if (decoded is! Map) {
        throw const FormatException(
          'El contenido CVLT2 no es un objeto JSON.',
        );
      }

      final data =
          AdvancedEncryptedData.fromJson(
        Map<String, dynamic>.from(decoded),
      );

      if (data.version != 2) {
        throw FormatException(
          'Versión CVLT2 no soportada: ${data.version}.',
        );
      }

      return data;
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException(
        'No fue posible leer el payload CVLT2.',
      );
    }
  }
}