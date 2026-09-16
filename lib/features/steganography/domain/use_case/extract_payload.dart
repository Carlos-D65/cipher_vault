import 'dart:typed_data';

import '../repositories/steganography_repository.dart';

class ExtractPayload {
  final SteganographyRepository repository;

  const ExtractPayload(this.repository);

  Future<String> call({
    required Uint8List imageBytes,
  }) {
    return repository.extractPayload(
      imageBytes: imageBytes,
    );
  }
}