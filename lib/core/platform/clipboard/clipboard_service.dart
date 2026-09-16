import 'package:flutter/services.dart';

abstract interface class ClipboardService {
  Future<void> copy(String text);
}

class FlutterClipboardService implements ClipboardService {
  const FlutterClipboardService();

  @override
  Future<void> copy(String text) {
    return Clipboard.setData(
      ClipboardData(text: text),
    );
  }
}