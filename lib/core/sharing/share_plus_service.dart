import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

import 'share_service.dart';

class SharePlusService implements ShareService {
  const SharePlusService();

  @override
  Future<void> shareText({
    required String text,
    String? subject,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: subject,
      ),
    );
  }

  @override
  Future<void> shareFileBytes({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
    String? subject,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        subject: subject,
        files: [
          XFile.fromData(
            bytes,
            mimeType: mimeType,
          ),
        ],
        fileNameOverrides: [
          fileName,
        ],
      ),
    );
  }
}