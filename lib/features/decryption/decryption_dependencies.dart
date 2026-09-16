import '../../core/security/services/encryption_service_factory.dart';
import '../../core/security/steganography/services/steganography_service.dart';
import '../../core/sharing/share_plus_service.dart';
import '../../core/storage/local_file_storage_service.dart';
import 'data/repositories/decryption_repository_impl.dart';
import 'domain/use_case/decrypt_text.dart';
import 'presentation/controllers/decrypt_controller.dart';
import 'presentation/providers/decrypt_provider.dart';

abstract final class DecryptionDependencies {
  static DecryptController createDecryptController() {
    final encryptionFactory =
        EncryptionServiceFactory();

    final repository = DecryptionRepositoryImpl(
      factory: encryptionFactory,
    );

    final decryptText = DecryptText(
      repository,
    );

    final provider = DecryptProvider();

    const steganographyService =
        PngSteganographyService();

    const fileStorage =
        LocalFileStorageService();

    const shareService =
        SharePlusService();

    return DecryptController(
      decryptText: decryptText,
      provider: provider,
      steganographyService: steganographyService,
      fileStorage: fileStorage,
      shareService: shareService,
    );
  }
}