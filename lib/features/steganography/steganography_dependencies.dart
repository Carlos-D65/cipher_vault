import '../../core/security/steganography/services/steganography_service.dart';
import '../../core/sharing/share_plus_service.dart';
import '../../core/storage/local_file_storage_service.dart';
import 'data/repositories/steganography_repository_impl.dart';
import 'domain/use_case/hide_payload.dart';
import 'presentation/controllers/hide_controller.dart';
import 'presentation/providers/hide_provider.dart';

abstract final class SteganographyDependencies {
  static HideController createHideController({
    String? initialPayload,
  }) {
    final repository = SteganographyRepositoryImpl(
      service: const PngSteganographyService(),
    );

    final hidePayload = HidePayload(repository);

    final provider = HideProvider();

    if (initialPayload != null &&
        initialPayload.trim().isNotEmpty) {
      provider.setPayload(
        initialPayload.trim(),
      );
    }

    const fileStorage = LocalFileStorageService();
    const shareService = SharePlusService();

    return HideController(
      hidePayload: hidePayload,
      provider: provider,
      fileStorage: fileStorage,
      shareService: shareService,
    );
  }
}