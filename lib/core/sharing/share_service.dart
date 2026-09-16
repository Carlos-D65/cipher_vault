import 'dart:typed_data';

abstract interface class ShareService {
  Future<void> shareText({
    required String text,
    String? subject,
  });

  Future<void> shareFileBytes({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
    String? subject,
  });
}