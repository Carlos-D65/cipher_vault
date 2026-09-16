import 'dart:typed_data';

abstract interface class FileStorageService {
  Future<String> saveTextFile({
    required String fileName,
    required String content,
  });

  Future<String> saveBytesFile({
    required String fileName,
    required Uint8List bytes,
  });
}