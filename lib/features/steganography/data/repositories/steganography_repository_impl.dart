import 'dart:typed_data';

import '../../../../core/security/steganography/services/steganography_service.dart';
import '../../domain/repositories/steganography_repository.dart';

class SteganographyRepositoryImpl
    implements SteganographyRepository {
  final SteganographyService service;

  SteganographyRepositoryImpl({
    SteganographyService? service,
  }) : service = service ?? const PngSteganographyService();

  @override
  Future<Uint8List> hidePayload({
    required Uint8List imageBytes,
    required String payload,
  }) {
    return service.hide(
      imageBytes: imageBytes,
      payload: payload,
    );
  }

  @override
  Future<String> extractPayload({
    required Uint8List imageBytes,
  }) {
    return service.extract(
      imageBytes: imageBytes,
    );
  }
}