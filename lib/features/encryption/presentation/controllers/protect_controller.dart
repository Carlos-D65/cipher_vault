import 'package:flutter/services.dart';

import '../../../../core/security/advanced/codec/advanced_cipher_vault_payload_codec.dart';
import '../../../../core/security/advanced/services/aes_ml_kem_encryption_service.dart';
import '../../../../core/security/advanced/services/advanced_encryption_service.dart';
import '../../../../core/security/advanced/services/chacha20_ml_kem_encryption_service.dart';
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

  final AdvancedEncryptionService _aesMlKemService;
  final AdvancedEncryptionService _chachaMlKemService;

  ProtectController({
    required this.encryptText,
    required this.provider,
    required this.fileStorage,
    required this.shareService,
    AdvancedEncryptionService? aesMlKemService,
    AdvancedEncryptionService? chachaMlKemService,
  })  : _aesMlKemService =
            aesMlKemService ??
                AesMlKemEncryptionService(),
        _chachaMlKemService =
            chachaMlKemService ??
                Chacha20MlKemEncryptionService();

  Future<void> encrypt({
    required String message,
    required String password,
    required EncryptionAlgorithm algorithm,
  }) async {
    final cleanMessage =
        message.trim();

    if (cleanMessage.isEmpty) {
      provider.setError(
        'Escribe un mensaje para cifrar.',
      );
      return;
    }

    if (password.isEmpty) {
      provider.setError(
        'Introduce una contraseña.',
      );
      return;
    }

    provider.setEncrypting();

    try {
      final encryptedData =
          await encryptText(
        plaintext: cleanMessage,
        password: password,
        algorithm: algorithm,
      );

      final payload =
          CipherVaultPayloadCodec.encode(
        encryptedData,
      );

      provider.setSuccess(
        encryptedData: encryptedData,
        encryptedPayload: payload,
      );
    } catch (_) {
      provider.setError(
        'No fue posible cifrar el mensaje.',
      );
    }
  }

  Future<void> encryptAdvanced({
    required String message,
    required String password,
    required EncryptionAlgorithm algorithm,
  }) async {
    final cleanMessage =
        message.trim();

    if (cleanMessage.isEmpty) {
      provider.setError(
        'Escribe un mensaje para cifrar.',
      );
      return;
    }

    if (password.isEmpty) {
      provider.setError(
        'Introduce una contraseña.',
      );
      return;
    }

    provider.setEncrypting();

    try {
      final AdvancedEncryptionService service;

      switch (algorithm) {
        case EncryptionAlgorithm.aes256Gcm:
          service =
              _aesMlKemService;
          break;

        case EncryptionAlgorithm
              .chacha20Poly1305:
          service =
              _chachaMlKemService;
          break;
      }

      final encryptedData =
          await service.encrypt(
        plaintext: cleanMessage,
        password: password,
      );

      final payload =
          AdvancedCipherVaultPayloadCodec
              .encode(
        encryptedData,
      );

      provider.setAdvancedSuccess(
        encryptedData:
            encryptedData,
        encryptedPayload:
            payload,
      );
    } catch (_) {
      provider.setError(
        'No fue posible realizar el cifrado avanzado.',
      );
    }
  }

  Future<void> copyPayload() async {
    final payload =
        provider.encryptedPayload;

    if (payload == null) {
      return;
    }

    await Clipboard.setData(
      ClipboardData(
        text: payload,
      ),
    );
  }

  Future<String?> savePayload() async {
    final payload = provider.encryptedPayload;

    if (payload == null || payload.isEmpty) {
      return null;
    }

    provider.setSaving();

    try {
      final fileName = provider.isAdvancedResult
          ? 'cipher_vault_payload_cvlt2.cvlt'
          : 'cipher_vault_payload.cvlt';

      final path =
          await fileStorage.saveTextFileWithPicker(
        fileName: fileName,
        content: payload,
        mimeType: 'application/octet-stream',
      );

      provider.restoreSuccessState();

      return path;
    } catch (e, stackTrace) {
      print('Error saving payload: $e');
      print(stackTrace);
      provider.setError(
        'No fue posible guardar el payload.',
      );

      return null;
    }
  }
  Future<bool> sharePayload() async {
    final payload =
        provider.encryptedPayload;

    if (payload == null) {
      return false;
    }

    provider.setSharing();

    try {
      await shareService.shareText(
        text: payload,
        subject:
            provider.isAdvancedResult
                ? 'CipherVault advanced encrypted payload'
                : 'CipherVault encrypted payload',
      );

      provider.restoreSuccessState();

      return true;
    } catch (_) {
      provider.setError(
        'No fue posible compartir el payload.',
      );

      return false;
    }
  }

  void reset() {
    provider.reset();
  }
}