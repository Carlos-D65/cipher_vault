
import 'package:file_picker/file_picker.dart';

import '../../../../core/security/codec/cipher_vault_payload_codec.dart';
import '../../../../core/sharing/share_service.dart';
import '../../../../core/storage/file_storage_service.dart';
import '../../domain/use_case/hide_payload.dart';
import '../providers/hide_provider.dart';

class HideController {
  final HidePayload hidePayload;
  final HideProvider provider;
  final FileStorageService fileStorage;
  final ShareService shareService;

  const HideController({
    required this.hidePayload,
    required this.provider,
    required this.fileStorage,
    required this.shareService,
  });

  Future<void> selectImage() async {
    if (provider.isBusy) {
      return;
    }

    provider.setSelectingImage();

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png'],
        allowMultiple: false,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        provider.restoreSuccess();
        return;
      }

      final file = result.files.single;

      final bytes = file.bytes;

      if (bytes == null || bytes.isEmpty) {
        provider.setError('No fue posible leer la imagen seleccionada.');
        return;
      }

      provider.setImage(bytes: bytes, fileName: file.name);
    } catch (_) {
      provider.setError('No fue posible seleccionar la imagen.');
    }
  }

  Future<void> hide() async {
    final imageBytes = provider.selectedImageBytes;
    final payload = provider.payload;

    if (imageBytes == null) {
      provider.setError('Selecciona una imagen PNG.');
      return;
    }

    if (payload == null || payload.trim().isEmpty) {
      provider.setError('Introduce un payload de CipherVault.');
      return;
    }

    try {
      CipherVaultPayloadCodec.decode(payload);

      provider.setProcessing();

      final protectedBytes = await hidePayload(
        imageBytes: imageBytes,
        payload: payload.trim(),
      );

      provider.setSuccess(protectedBytes);
    } on FormatException catch (error) {
      provider.setError(error.message);
    } catch (_) {
      provider.setError('No fue posible ocultar el payload en la imagen.');
    }
  }

  Future<String?> saveImage() async {
    final bytes = provider.protectedImageBytes;

    if (bytes == null) {
      return null;
    }

    provider.setSaving();

    try {
      final path = await fileStorage.saveBytesFileWithPicker(
        fileName: _buildOutputFileName(),
        bytes: bytes,
        mimeType: 'image/png',
      );

      provider.setSaved(path);

      return path;
    } catch (_) {
      provider.setError('No fue posible guardar la imagen protegida.');

      return null;
    }
  }

  Future<bool> shareImage() async {
    final bytes = provider.protectedImageBytes;

    if (bytes == null) {
      return false;
    }

    provider.setSharing();

    try {
      await shareService.shareFileBytes(
        bytes: bytes,
        fileName: _buildOutputFileName(),
        mimeType: 'image/png',
        subject: 'CipherVault protected image',
      );

      provider.restoreSuccess();

      return true;
    } catch (_) {
      provider.setError('No fue posible compartir la imagen protegida.');

      return false;
    }
  }

  String _buildOutputFileName() {
    final original = provider.selectedFileName;

    if (original == null || original.isEmpty) {
      return 'cipher_vault_protected.png';
    }

    final withoutExtension = original.replaceFirst(
      RegExp(r'\.png$', caseSensitive: false),
      '',
    );

    return '${withoutExtension}_cipher_vault.png';
  }

  void reset() {
    provider.reset();
  }
}
