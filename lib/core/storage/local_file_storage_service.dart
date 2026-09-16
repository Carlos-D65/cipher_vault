import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import 'file_storage_service.dart';

class LocalFileStorageService implements FileStorageService {
  const LocalFileStorageService();

  @override
  Future<String> saveTextFile({
    required String fileName,
    required String content,
  }) async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File(
      '${directory.path}/$fileName',
    );

    await file.writeAsString(
      content,
      flush: true,
    );

    return file.path;
  }

  @override
  Future<String> saveBytesFile({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File(
      '${directory.path}/$fileName',
    );

    await file.writeAsBytes(
      bytes,
      flush: true,
    );

    return file.path;
  }
}