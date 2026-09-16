import 'dart:typed_data';

abstract interface class SteganographyRepository {
  Future<Uint8List> hidePayload({
    required Uint8List imageBytes,
    required String payload,
  });

  Future<String> extractPayload({
    required Uint8List imageBytes,
  });
}