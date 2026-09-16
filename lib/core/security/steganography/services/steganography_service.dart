import 'dart:typed_data';

import '../codec/steganography_codec.dart';

abstract interface class SteganographyService {
  Future<Uint8List> hide({
    required Uint8List imageBytes,
    required String payload,
  });

  Future<String> extract({
    required Uint8List imageBytes,
  });
}

class PngSteganographyService
    implements SteganographyService {
  final SteganographyCodec codec;

  const PngSteganographyService({
    this.codec = const SteganographyCodec(),
  });

  @override
  Future<Uint8List> hide({
    required Uint8List imageBytes,
    required String payload,
  }) async {
    return codec.encode(
      imageBytes: imageBytes,
      payload: payload,
    );
  }

  @override
  Future<String> extract({
    required Uint8List imageBytes,
  }) async {
    return codec.decode(
      imageBytes: imageBytes,
    );
  }
}