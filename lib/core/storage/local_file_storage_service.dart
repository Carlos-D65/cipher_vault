import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'file_storage_service.dart';
import 'picked_data.dart';

class LocalFileStorageService implements FileStorageService {
  const LocalFileStorageService();

  @override
  Future<String> saveTextFile({
    required String fileName,
    required String content,
  }) async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/$fileName');

    await file.writeAsString(
      content,
      encoding: utf8,
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

    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(
      bytes,
      flush: true,
    );

    return file.path;
  }

  @override
  Future<String> saveTextFileWithPicker({
    required String fileName,
    required String content,
    required String mimeType,
  }) async {
    final bytes = Uint8List.fromList(
      utf8.encode(content),
    );

    return saveBytesFileWithPicker(
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
    final extension = _getExtension(fileName);

    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar archivo',
      fileName: fileName,
      bytes: bytes,
      type: FileType.custom,
      allowedExtensions: [extension],
    );

    if (path == null) {
      throw Exception(
        'No se seleccionó ninguna ubicación para guardar el archivo.',
      );
    }

    return path;
  }

  String _getExtension(String fileName) {
    final index = fileName.lastIndexOf('.');

    if (index == -1 || index == fileName.length - 1) {
      return '';
    }

    return fileName.substring(index + 1);
  }
  @override
  Future<PickedFileData?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['cvlt'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = result.files.single;

    Uint8List? bytes = file.bytes;

    if (bytes == null && file.path != null) {
      bytes = await File(file.path!).readAsBytes();
    }

    if (bytes == null) {
      throw Exception(
        'No fue posible leer el archivo seleccionado.',
      );
    }

    return PickedFileData(
      fileName: file.name,
      bytes: bytes,
    );
  }
}