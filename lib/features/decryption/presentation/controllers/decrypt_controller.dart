import 'package:cryptography/cryptography.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import '../../../../core/security/codec/cipher_vault_payload_codec.dart';
import '../../../../core/security/steganography/services/steganography_service.dart';
import '../../../../core/sharing/share_service.dart';
import '../../../../core/storage/file_storage_service.dart';
import '../../domain/use_case/decrypt_text.dart';
import '../providers/decrypt_provider.dart';

class DecryptController {
  final DecryptText decryptText;
  final DecryptProvider provider;
  final SteganographyService steganographyService;
  final FileStorageService fileStorage;
  final ShareService shareService;

  const DecryptController({
    required this.decryptText,
    required this.provider,
    required this.steganographyService,
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
        provider.setError(
          'No fue posible leer la imagen seleccionada.',
        );
        return;
      }

      provider.setImage(
        bytes: bytes,
        fileName: file.name,
      );
    } catch (_) {
      provider.setError(
        'No fue posible seleccionar la imagen.',
      );
    }
  }

  Future<void> extractFromImage() async {
    final imageBytes = provider.selectedImageBytes;

    if (imageBytes == null) {
      provider.setError(
        'Selecciona una imagen PNG protegida.',
      );
      return;
    }

    provider.setExtracting();

    try {
      final payload = await steganographyService.extract(
        imageBytes: imageBytes,
      );

      CipherVaultPayloadCodec.decode(payload);

      provider.setPayload(payload);
    } on FormatException catch (error) {
      provider.setError(error.message);
    } catch (_) {
      provider.setError(
        'No fue posible extraer el payload de la imagen.',
      );
    }
  }

  Future<void> decryptPayload({
    required String password,
  }) async {
    final payload = provider.payload;

    if (payload == null || payload.trim().isEmpty) {
      provider.setError(
        'Primero selecciona una imagen protegida.',
      );
      return;
    }

    if (password.isEmpty) {
      provider.setError(
        'Introduce una contraseña.',
      );
      return;
    }

    provider.setDecrypting();

    try {
      final encryptedData =
          CipherVaultPayloadCodec.decode(
        payload.trim(),
      );

      final decrypted = await decryptText(
        encryptedData: encryptedData,
        password: password,
      );

      provider.setSuccess(decrypted);
    } on FormatException catch (error) {
      provider.setError(error.message);
    } on SecretBoxAuthenticationError {
      provider.setError(
        'La contraseña es incorrecta o los datos fueron modificados.',
      );
    } catch (_) {
      provider.setError(
        'No fue posible descifrar el mensaje.',
      );
    }
  }

  Future<void> decryptPayloadText({
    required String payload,
    required String password,
  }) async {
    final cleanPayload = payload.trim();

    if (cleanPayload.isEmpty) {
      provider.setError(
        'Introduce un payload de CipherVault.',
      );
      return;
    }

    if (password.isEmpty) {
      provider.setError(
        'Introduce una contraseña.',
      );
      return;
    }

    provider.setPayload(cleanPayload);

    await decryptPayload(
      password: password,
    );
  }

  Future<void> copyDecryptedText() async {
    final text = provider.decryptedText;

    if (text == null) {
      return;
    }

    provider.setCopying();

    try {
      await Clipboard.setData(
        ClipboardData(
          text: text,
        ),
      );

      provider.restoreSuccess();
    } catch (_) {
      provider.setError(
        'No fue posible copiar el mensaje.',
      );
    }
  }

  Future<String?> saveDecryptedText() async {
    final text = provider.decryptedText;

    if (text == null) {
      return null;
    }

    provider.setSaving();

    try {
      final path = await fileStorage.saveTextFile(
        fileName: 'cipher_vault_decrypted.txt',
        content: text,
      );

      provider.setSaved(path);

      return path;
    } catch (_) {
      provider.setError(
        'No fue posible guardar el mensaje.',
      );

      return null;
    }
  }

  Future<bool> shareDecryptedText() async {
    final text = provider.decryptedText;

    if (text == null) {
      return false;
    }

    provider.setSharing();

    try {
      await shareService.shareText(
        text: text,
        subject: 'CipherVault decrypted message',
      );

      provider.restoreSuccess();

      return true;
    } catch (_) {
      provider.setError(
        'No fue posible compartir el mensaje.',
      );

      return false;
    }
  }

  void clearPayload() {
    provider.setPayload('');
  }

  void reset() {
    provider.reset();
  }
}