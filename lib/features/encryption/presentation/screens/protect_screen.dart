import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/security/models/encryption_algorithm.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/widgets/cipher_vault_bottom_navigation.dart';
import '../controllers/protect_controller.dart';
import '../providers/protect_provider.dart';
import '../widgets/encrypted_result_card.dart';
import '../widgets/encryption_algorithm_selector.dart';

class ProtectScreen extends StatefulWidget {
  final ProtectController controller;

  const ProtectScreen({
    super.key,
    required this.controller,
  });

  @override
  State<ProtectScreen> createState() => _ProtectScreenState();
}

class _ProtectScreenState extends State<ProtectScreen> {
  final TextEditingController _messageController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  EncryptionAlgorithm _algorithm =
      EncryptionAlgorithm.aes256Gcm;

  @override
  void dispose() {
    _messageController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _encrypt() async {
    FocusScope.of(context).unfocus();

    await widget.controller.encrypt(
      message: _messageController.text,
      password: _passwordController.text,
      algorithm: _algorithm,
    );

    if (!mounted) {
      return;
    }

    if (widget.controller.provider.hasResult) {
      _passwordController.clear();
    }
  }

  Future<void> _copyPayload() async {
    await widget.controller.copyPayload();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Encrypted payload copied.',
        ),
      ),
    );
  }

  Future<void> _savePayload() async {
    final path =
        await widget.controller.savePayload();

    if (!mounted) {
      return;
    }

    if (path != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Encrypted payload saved.',
          ),
        ),
      );
    }
  }

  Future<void> _sharePayload() async {
    final success =
        await widget.controller.sharePayload();

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Encrypted payload shared.',
          ),
        ),
      );
    }
  }

  void _openHide() {
    final payload =
        widget.controller.provider.encryptedPayload;

    if (payload == null) {
      return;
    }

    Navigator.of(context).pushNamed(
      '/hide',
      arguments: payload,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProtectProvider>.value(
      value: widget.controller.provider,
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true,

        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: const Text(
            'Protect',
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
          child: Consumer<ProtectProvider>(
            builder: (
              context,
              provider,
              _,
            ) {
              return LayoutBuilder(
                builder: (
                  context,
                  constraints,
                ) {
                  final horizontalPadding =
                      constraints.maxWidth < 360
                          ? 16.0
                          : 20.0;

                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior
                            .onDrag,
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      12,
                      horizontalPadding,
                      32,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 520,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'ENCRYPT MESSAGE',
                              style: TextStyle(
                                color: AppColors.cyan,
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.w800,
                                letterSpacing: 1.4,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Protect your information with strong encryption.',
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 28),

                            _buildMessageField(
                              provider,
                            ),

                            const SizedBox(height: 18),

                            _buildPasswordField(
                              provider,
                            ),

                            const SizedBox(height: 18),

                            EncryptionAlgorithmSelector(
                              value: _algorithm,
                              enabled: !provider.isBusy,
                              onChanged: (algorithm) {
                                setState(() {
                                  _algorithm = algorithm;
                                });
                              },
                            ),

                            const SizedBox(height: 24),

                            _buildEncryptButton(
                              provider,
                            ),

                            if (provider.errorMessage !=
                                null) ...[
                              const SizedBox(height: 18),
                              _buildError(
                                provider.errorMessage!,
                              ),
                            ],

                            if (provider.hasResult) ...[
                              const SizedBox(height: 24),
                              EncryptedResultCard(
                                payload:
                                    provider.encryptedPayload!,
                                onCopy: _copyPayload,
                                onSave: _savePayload,
                                onShare: _sharePayload,
                                onHide: _openHide,
                                isSaving:
                                    provider.isSaving,
                                isSharing:
                                    provider.isSharing,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        bottomNavigationBar:
            const CipherVaultBottomNavigation(
          currentIndex: 1,
        ),
      ),
    );
  }

  Widget _buildMessageField(
    ProtectProvider provider,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'MESSAGE',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: _messageController,
          enabled: !provider.isBusy,
          minLines: 7,
          maxLines: 12,
          keyboardType: TextInputType.multiline,
          textCapitalization:
              TextCapitalization.sentences,
          style: const TextStyle(
            color: AppColors.text,
          ),
          decoration: InputDecoration(
            hintText:
                'Write the message you want to protect...',
            hintStyle: const TextStyle(
              color: AppColors.subtle,
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.cyan,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    ProtectProvider provider,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'PASSWORD',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: _passwordController,
          enabled: !provider.isBusy,
          obscureText: true,
          style: const TextStyle(
            color: AppColors.text,
          ),
          decoration: InputDecoration(
            hintText: 'Enter password',
            hintStyle: const TextStyle(
              color: AppColors.subtle,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.muted,
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.cyan,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEncryptButton(
    ProtectProvider provider,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed:
            provider.isBusy ? null : _encrypt,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cyan,
          foregroundColor: Colors.black,
          disabledBackgroundColor:
              AppColors.cyanDark,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),
        child: provider.isEncrypting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'ENCRYPT',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.errorBackground,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.error.withValues(
            alpha: 0.35,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}