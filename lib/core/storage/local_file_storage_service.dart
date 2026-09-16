import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
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

    final file = File('${directory.path}/$fileName');

    await file.writeAsString(content, encoding: utf8, flush: true);

    return file.path;
  }

  @override
  Future<String> saveBytesFile({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(bytes, flush: true);

    return file.path;
  }

  @override
  Future<String> saveTextFileWithPicker({
    required String fileName,
    required String content,
    required String mimeType,
  }) async {
    final bytes = Uint8List.fromList(utf8.encode(content));
    return await saveBytesFileWithPicker(
      fileName: fileName,
      bytes: bytes,
      mimeType: mimeType,
    );
  }

  @override
  Future<String> saveBytesFileWithPicker({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  }) async {
    final url = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar archivo',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: [mimeType],
    );
    if (url == null) {
      throw Exception('No se seleccionó ninguna ubicación para guardar el archivo.');
    }
    return url.toString();
  }
}
