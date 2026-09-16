import '../../core/security/services/encryption_service_factory.dart';
import '../../core/sharing/share_plus_service.dart';
import '../../core/storage/local_file_storage_service.dart';
import 'data/repositories/encryption_repository_impl.dart';
import 'domain/use_cases/encrypy_text.dart';
import 'presentation/controllers/protect_controller.dart';
import 'presentation/providers/protect_provider.dart';

abstract final class EncryptionDependencies {
  static ProtectController createProtectController() {
    final repository = EncryptionRepositoryImpl(
      factory: EncryptionServiceFactory(),
    );

    final encryptText = EncryptText(repository);
    final provider = ProtectProvider();

    const fileStorage = LocalFileStorageService();
    const shareService = SharePlusService();

    return ProtectController(
      encryptText: encryptText,
      provider: provider,
      fileStorage: fileStorage,
      shareService: shareService,
    );
  }
}
