import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

class SteganographyCodec {
  static const List<int> _magic = [0x43, 0x56, 0x53, 0x54]; // CVST
  static const int _version = 1;

  static const int _headerLength = 9;
  static const int _bitsPerPixel = 3;

  const SteganographyCodec();

  Uint8List encode({
    required Uint8List imageBytes,
    required String payload,
  }) {
    _validatePng(imageBytes);

    if (payload.isEmpty) {
      throw const FormatException(
        'El payload no puede estar vacío.',
      );
    }

    final image = img.decodeImage(imageBytes);

    if (image == null) {
      throw const FormatException(
        'No fue posible decodificar la imagen PNG.',
      );
    }

    final payloadBytes = utf8.encode(payload);

    final frame = _buildFrame(payloadBytes);

    final capacityBits =
        image.width * image.height * _bitsPerPixel;

    final requiredBits = frame.length * 8;

    if (requiredBits > capacityBits) {
      throw FormatException(
        'La imagen no tiene capacidad suficiente. '
        'Necesita $requiredBits bits y solo tiene '
        '$capacityBits bits disponibles.',
      );
    }

    _writeBits(
      image: image,
      data: frame,
    );

    return Uint8List.fromList(
      img.encodePng(image),
    );
  }

  String decode({
    required Uint8List imageBytes,
  }) {
    _validatePng(imageBytes);

    final image = img.decodeImage(imageBytes);

    if (image == null) {
      throw const FormatException(
        'No fue posible decodificar la imagen PNG.',
      );
    }

    final headerBytes = _readBytes(
      image: image,
      byteCount: _headerLength,
    );

    _validateHeader(headerBytes);

    final payloadLength = _readUint32(
      headerBytes,
      offset: 5,
    );

    final totalLength =
        _headerLength + payloadLength + 4;

    final capacityBytes =
        (image.width * image.height * _bitsPerPixel) ~/ 8;

    if (totalLength > capacityBytes) {
      throw const FormatException(
        'El tamaño del payload almacenado no es válido.',
      );
    }

    final frame = _readBytes(
      image: image,
      byteCount: totalLength,
    );

    final payloadStart = _headerLength;
    final payloadEnd = payloadStart + payloadLength;

    final payloadBytes = frame.sublist(
      payloadStart,
      payloadEnd,
    );

    final storedCrc = _readUint32(
      frame,
      offset: payloadEnd,
    );

    final calculatedCrc = _crc32(payloadBytes);

    if (storedCrc != calculatedCrc) {
      throw const FormatException(
        'La imagen no contiene un payload válido de CipherVault '
        'o fue modificada.',
      );
    }

    try {
      return utf8.decode(payloadBytes);
    } catch (_) {
      throw const FormatException(
        'El payload oculto no contiene texto UTF-8 válido.',
      );
    }
  }

  List<int> _buildFrame(List<int> payload) {
    final frame = <int>[];

    frame.addAll(_magic);
    frame.add(_version);

    _writeUint32(frame, payload.length);

    frame.addAll(payload);

    final crc = _crc32(payload);

    _writeUint32(frame, crc);

    return frame;
  }

  void _writeBits({
    required img.Image image,
    required List<int> data,
  }) {
    var bitIndex = 0;

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);

        final channels = <num>[
          pixel.r,
          pixel.g,
          pixel.b,
        ];

        for (var channel = 0; channel < 3; channel++) {
          if (bitIndex >= data.length * 8) {
            return;
          }

          final byteIndex = bitIndex ~/ 8;
          final bitPosition = 7 - (bitIndex % 8);

          final bit =
              (data[byteIndex] >> bitPosition) & 1;

          channels[channel] =
              (channels[channel].toInt() & 0xFE) | bit;

          bitIndex++;
        }

        pixel
          ..r = channels[0]
          ..g = channels[1]
          ..b = channels[2];
      }
    }
  }

  List<int> _readBytes({
    required img.Image image,
    required int byteCount,
  }) {
    final result = <int>[];

    var currentByte = 0;
    var bitsRead = 0;

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);

        final channels = <num>[
          pixel.r,
          pixel.g,
          pixel.b,
        ];

        for (final channel in channels) {
          currentByte =
              (currentByte << 1) |
              (channel.toInt() & 1);

          bitsRead++;

          if (bitsRead == 8) {
            result.add(currentByte);
            currentByte = 0;
            bitsRead = 0;

            if (result.length == byteCount) {
              return result;
            }
          }
        }
      }
    }

    throw const FormatException(
      'La imagen no contiene suficientes datos.',
    );
  }

  void _validateHeader(List<int> header) {
    if (header.length < _headerLength) {
      throw const FormatException(
        'La cabecera de CipherVault está incompleta.',
      );
    }

    for (var i = 0; i < _magic.length; i++) {
      if (header[i] != _magic[i]) {
        throw const FormatException(
          'La imagen no contiene un payload de CipherVault.',
        );
      }
    }

    if (header[4] != _version) {
      throw FormatException(
        'Versión de steganography no soportada: ${header[4]}',
      );
    }
  }

  int _readUint32(
    List<int> bytes, {
    required int offset,
  }) {
    return (bytes[offset] << 24) |
        (bytes[offset + 1] << 16) |
        (bytes[offset + 2] << 8) |
        bytes[offset + 3];
  }

  void _writeUint32(
    List<int> output,
    int value,
  ) {
    output.add((value >> 24) & 0xFF);
    output.add((value >> 16) & 0xFF);
    output.add((value >> 8) & 0xFF);
    output.add(value & 0xFF);
  }

  int _crc32(List<int> bytes) {
    var crc = 0xFFFFFFFF;

    for (final byte in bytes) {
      crc ^= byte;

      for (var i = 0; i < 8; i++) {
        final mask = -(crc & 1);
        crc =
            (crc >> 1) ^
            (0xEDB88320 & mask);
      }
    }

    return (~crc) & 0xFFFFFFFF;
  }

  void _validatePng(Uint8List bytes) {
    const pngSignature = <int>[
      0x89,
      0x50,
      0x4E,
      0x47,
      0x0D,
      0x0A,
      0x1A,
      0x0A,
    ];

    if (bytes.length < pngSignature.length) {
      throw const FormatException(
        'El archivo no es un PNG válido.',
      );
    }

    for (var i = 0; i < pngSignature.length; i++) {
      if (bytes[i] != pngSignature[i]) {
        throw const FormatException(
          'CipherVault requiere imágenes PNG.',
        );
      }
    }
  }
}