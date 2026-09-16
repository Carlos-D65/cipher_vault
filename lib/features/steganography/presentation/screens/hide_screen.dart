import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../controllers/hide_controller.dart';
import '../providers/hide_provider.dart';
import '../../../home/presentation/widgets/cipher_vault_bottom_navigation.dart';

class HideScreen extends StatefulWidget {
  final HideController controller;

  const HideScreen({
    super.key,
    required this.controller,
  });

  @override
  State<HideScreen> createState() => _HideScreenState();
}

class _HideScreenState extends State<HideScreen> {
  late final TextEditingController _payloadController;

  @override
  void initState() {
    super.initState();

    _payloadController = TextEditingController(
      text: widget.controller.provider.payload ?? '',
    );
  }

  @override
  void dispose() {
    _payloadController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    FocusScope.of(context).unfocus();

    await widget.controller.selectImage();
  }

  Future<void> _hide() async {
    FocusScope.of(context).unfocus();

    widget.controller.provider.setPayload(
      _payloadController.text,
    );

    await widget.controller.hide();
  }

  Future<void> _save() async {
    final path = await widget.controller.saveImage();

    if (!mounted) {
      return;
    }

    if (path != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Imagen protegida guardada correctamente.',
          ),
        ),
      );
    }
  }

  Future<void> _share() async {
    final success = await widget.controller.shareImage();

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Imagen protegida compartida.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HideProvider>.value(
      value: widget.controller.provider,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: const Text(
            'Hide',
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
            ),
          ),
          iconTheme: const IconThemeData(
            color: AppColors.text,
          ),
        ),
        body: SafeArea(
          child: Consumer<HideProvider>(
            builder: (
              context,
              provider,
              _,
            ) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  32,
                ),
                children: [
                  const Text(
                    'HIDE ENCRYPTED DATA',
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hide an encrypted CipherVault payload inside a PNG image.',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 26),
                  _buildImageSection(provider),
                  const SizedBox(height: 22),
                  _buildPayloadField(provider),
                  const SizedBox(height: 22),
                  _buildHideButton(provider),
                  if (provider.errorMessage != null) ...[
                    const SizedBox(height: 18),
                    _buildError(
                      provider.errorMessage!,
                    ),
                  ],
                  if (provider.hasResult) ...[
                    const SizedBox(height: 24),
                    _buildResult(provider),
                  ],
                ],
              );
            },
          ),
        ),
                bottomNavigationBar: const CipherVaultBottomNavigation(
          currentIndex: 3,
        ),
      ),
    );
  }

  Widget _buildImageSection(
    HideProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PNG IMAGE',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: provider.isBusy
              ? null
              : _selectImage,
          child: Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: provider.hasImage
                    ? AppColors.cyan.withValues(
                        alpha: 0.45,
                      )
                    : AppColors.border,
              ),
            ),
            child: provider.selectedImageBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.memory(
                      provider.selectedImageBytes!,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        color: AppColors.cyan,
                        size: 42,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'SELECT PNG',
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Only PNG images are supported.',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (provider.selectedFileName != null) ...[
          const SizedBox(height: 9),
          Text(
            provider.selectedFileName!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPayloadField(
    HideProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ENCRYPTED PAYLOAD',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _payloadController,
          enabled: !provider.isBusy,
          minLines: 5,
          maxLines: 10,
          style: const TextStyle(
            color: AppColors.text,
            fontFamily: 'monospace',
            fontSize: 11,
            height: 1.45,
          ),
          decoration: InputDecoration(
            hintText: 'CVLT1....',
            hintStyle: const TextStyle(
              color: AppColors.subtle,
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.cyan,
              ),
            ),
          ),
          onChanged: widget.controller.provider.setPayload,
        ),
      ],
    );
  }

  Widget _buildHideButton(
    HideProvider provider,
  ) {
    final processing =
        provider.status == HideStatus.processing;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: provider.isBusy ? null : _hide,
        icon: processing
            ? const SizedBox(
                width: 19,
                height: 19,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              )
            : const Icon(
                Icons.visibility_off_outlined,
              ),
        label: Text(
          processing ? 'HIDING...' : 'HIDE PAYLOAD',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cyan,
          foregroundColor: Colors.black,
          disabledBackgroundColor:
              AppColors.cyanDark,
          disabledForegroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildResult(
    HideProvider provider,
  ) {
    final saving =
        provider.status == HideStatus.saving;

    final sharing =
        provider.status == HideStatus.sharing;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.green.withValues(
            alpha: 0.35,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.verified_rounded,
                color: AppColors.green,
                size: 21,
              ),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'PAYLOAD HIDDEN SUCCESSFULLY',
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              provider.protectedImageBytes!,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: saving
                      ? null
                      : _save,
                  icon: saving
                      ? const SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.save_outlined,
                          size: 18,
                        ),
                  label: Text(
                    saving ? 'SAVING...' : 'SAVE',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: sharing
                      ? null
                      : _share,
                  icon: sharing
                      ? const SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Icon(
                          Icons.share_outlined,
                          size: 18,
                        ),
                  label: Text(
                    sharing ? 'SHARING...' : 'SHARE',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cyan,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.errorBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.error.withValues(
            alpha: 0.35,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
