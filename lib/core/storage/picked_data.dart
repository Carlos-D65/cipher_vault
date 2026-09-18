import 'dart:convert';
import 'dart:typed_data';

class PickedFileData {
  final String fileName;
  final Uint8List bytes;

  const PickedFileData({
    required this.fileName,
    required this.bytes,
  });

  String get content => utf8.decode(bytes);
}