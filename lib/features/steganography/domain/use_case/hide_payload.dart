import 'dart:typed_data';

import '../repositories/steganography_repository.dart';

class HidePayload {
  final SteganographyRepository repository;

  const HidePayload(this.repository);

  Future<Uint8List> call({
    required Uint8List imageBytes,
    required String payload,
  }) {
    return repository.hidePayload(
      imageBytes: imageBytes,
      payload: payload,
    );
  }
}