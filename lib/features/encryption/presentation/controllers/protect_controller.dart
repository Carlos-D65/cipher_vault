import 'package:flutter/services.dart';

import '../../../../core/security/codec/cipher_vault_payload_codec.dart';
import '../../../../core/security/models/encryption_algorithm.dart';
import '../../../../core/sharing/share_service.dart';
import '../../../../core/storage/file_storage_service.dart';
import '../../domain/use_cases/encrypy_text.dart';
import '../providers/protect_provider.dart';

class ProtectController {
  final EncryptText encryptText;
  final ProtectProvider provider;
  final FileStorageService fileStorage;
  final ShareService shareService;

  const ProtectController({
    required this.encryptText,
    required this.provider,
    required this.fileStorage,
    required this.shareService,
  });

  Future<void> encrypt({
    required String message,
    required String password,
    required EncryptionAlgorithm algorithm,
  }) async {
    final cleanMessage = message.trim();

    if (cleanMessage.isEmpty) {
      provider.setError('Escribe un mensaje para cifrar.');
      return;
    }

    if (password.isEmpty) {
      provider.setError('Introduce una contraseña.');
      return;
    }

    provider.setEncrypting();

    try {
      final encryptedData = await encryptText(
        plaintext: cleanMessage,
        password: password,
        algorithm: algorithm,
      );

      final payload = CipherVaultPayloadCodec.encode(encryptedData);

      provider.setSuccess(
        encryptedData: encryptedData,
        encryptedPayload: payload,
      );
    } catch (_) {
      provider.setError('No fue posible cifrar el mensaje.');
    }
  }

  Future<void> copyPayload() async {
    final payload = provider.encryptedPayload;

    if (payload == null) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: payload));
  }

  Future<String?> savePayload() async {
    final payload = provider.encryptedPayload;

    if (payload == null) {
      return null;
    }

    provider.setSaving();

    try {
      final path = await fileStorage.saveTextFile(
        fileName: 'cipher_vault_payload.cvlt',
        content: payload,
      );

      provider.restoreSuccessState();

      return path;
    } catch (_) {
      provider.setError('No fue posible guardar el payload.');

      return null;
    }
  }

  Future<bool> sharePayload() async {
    final payload = provider.encryptedPayload;

    if (payload == null) {
      return false;
    }

    provider.setSharing();

    try {
      await shareService.shareText(
        text: payload,
        subject: 'CipherVault encrypted payload',
      );

      provider.restoreSuccessState();

      return true;
    } catch (_) {
      provider.setError('No fue posible compartir el payload.');

      return false;
    }
  }

  void reset() {
    provider.reset();
  }
}
