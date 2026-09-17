import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/widgets/cipher_vault_bottom_navigation.dart';
import '../controllers/decrypt_controller.dart';
import '../providers/decrypt_provider.dart';

class DecryptScreen extends StatefulWidget {
  final DecryptController controller;

  const DecryptScreen({
    super.key,
    required this.controller,
  });

  @override
  State<DecryptScreen> createState() =>
      _DecryptScreenState();
}

class _DecryptScreenState
    extends State<DecryptScreen> {
  late final TextEditingController
      _payloadController;

  late final TextEditingController
      _passwordController;

  @override
  void initState() {
    super.initState();

    _payloadController =
        TextEditingController();

    _passwordController =
        TextEditingController();
  }

  @override
  void dispose() {
    _payloadController.dispose();
    _passwordController.dispose();

    widget.controller.reset();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return ChangeNotifierProvider<
        DecryptProvider>.value(
      value:
          widget.controller.provider,
      child: Scaffold(
        backgroundColor:
            AppColors.background,
        resizeToAvoidBottomInset:
            true,
        appBar: AppBar(
          backgroundColor:
              AppColors.background,
          elevation: 0,
          title: const Text(
            'Descifrar',
            style: TextStyle(
              color: AppColors.text,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
          iconTheme:
              const IconThemeData(
            color: AppColors.text,
          ),
        ),
        body: SafeArea(
          child: Consumer<
              DecryptProvider>(
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
                      constraints.maxWidth <
                              360
                          ? 16.0
                          : 20.0;

                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior
                            .onDrag,
                    padding:
                        EdgeInsets.fromLTRB(
                      horizontalPadding,
                      12,
                      horizontalPadding,
                      32,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(
                          maxWidth: 520,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .stretch,
                          children: [
                            const Text(
                              'DESCIFRAR MENSAJE',
                              style:
                                  TextStyle(
                                color:
                                    AppColors.cyan,
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.w800,
                                letterSpacing:
                                    1.4,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            const Text(
                              'Descifra mensajes estándar CVLT1 o avanzados CVLT2.',
                              style:
                                  TextStyle(
                                color:
                                    AppColors.muted,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(
                              height: 24,
                            ),

                            _buildImageSelector(
                              provider,
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            _buildPayloadField(
                              provider,
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            _buildPasswordField(
                              provider,
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            _buildDecryptButton(
                              provider,
                            ),

                            if (provider.isBusy) ...[
                              const SizedBox(
                                height: 20,
                              ),
                              const Center(
                                child:
                                    CircularProgressIndicator(),
                              ),
                            ],

                            if (provider.errorMessage !=
                                null) ...[
                              const SizedBox(
                                height: 20,
                              ),
                              _buildError(
                                provider
                                    .errorMessage!,
                              ),
                            ],

                            if (provider.decryptedText !=
                                null) ...[
                              const SizedBox(
                                height: 24,
                              ),
                              _buildResult(
                                provider,
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
          currentIndex: 2,
        ),
      ),
    );
  }

  Widget _buildImageSelector(
    DecryptProvider provider,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        OutlinedButton(
          onPressed: provider.isBusy
              ? null
              : () async {
                  await widget.controller
                      .selectImage();

                  if (!mounted) {
                    return;
                  }

                  final payload =
                      widget.controller
                          .provider
                          .payload;

                  if (payload != null &&
                      payload.isNotEmpty) {
                    _payloadController
                            .text =
                        payload;
                  }
                },
          child: Text(
            provider.hasImage
                ? 'IMAGEN SELECCIONADA'
                : 'SELECCIONAR IMAGEN PNG',
          ),
        ),

        if (provider.selectedFileName !=
            null) ...[
          const SizedBox(
            height: 8,
          ),
          Text(
            provider.selectedFileName!,
            textAlign:
                TextAlign.center,
            overflow:
                TextOverflow.ellipsis,
            maxLines: 2,
            style:
                const TextStyle(
              color:
                  AppColors.muted,
            ),
          ),
        ],

        if (provider.hasImage) ...[
          const SizedBox(
            height: 12,
          ),

          LayoutBuilder(
            builder: (
              context,
              constraints,
            ) {
              final imageHeight =
                  constraints.maxWidth <
                          360
                      ? 150.0
                      : 180.0;

              return SizedBox(
                height:
                    imageHeight,
                width:
                    double.infinity,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius
                          .circular(
                    12,
                  ),
                  child:
                      Image.memory(
                    provider
                        .selectedImageBytes!,
                    fit:
                        BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          const SizedBox(
            height: 12,
          ),

          OutlinedButton(
            onPressed: provider.isBusy
                ? null
                : () async {
                    await widget
                        .controller
                        .extractFromImage();

                    if (!mounted) {
                      return;
                    }

                    final payload =
                        widget.controller
                            .provider
                            .payload;

                    if (payload != null &&
                        payload.isNotEmpty) {
                      _payloadController
                              .text =
                          payload;
                    }
                  },
            child: const Text(
              'EXTRAER PAYLOAD',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPayloadField(
    DecryptProvider provider,
  ) {
    return TextField(
      controller:
          _payloadController,
      enabled:
          !provider.isBusy,
      minLines: 4,
      maxLines: 8,
      keyboardType:
          TextInputType.multiline,
      style: const TextStyle(
        color: AppColors.text,
      ),
      decoration:
          const InputDecoration(
        labelText: 'Payload',
        hintText:
            'CVLT1... o CVLT2...',
      ),
      onChanged:
          provider.setPayload,
    );
  }

  Widget _buildPasswordField(
    DecryptProvider provider,
  ) {
    return TextField(
      controller:
          _passwordController,
      enabled:
          !provider.isBusy,
      obscureText: true,
      style: const TextStyle(
        color: AppColors.text,
      ),
      decoration:
          const InputDecoration(
        labelText: 'Contraseña',
        hintText:
            'Introduce tu contraseña',
      ),
    );
  }

  Widget _buildDecryptButton(
    DecryptProvider provider,
  ) {
    return SizedBox(
      width:
          double.infinity,
      child:
          ElevatedButton(
        onPressed: provider.isBusy
            ? null
            : () async {
                FocusScope.of(
                  context,
                ).unfocus();

                await widget
                    .controller
                    .decryptPayloadText(
                  payload:
                      _payloadController
                          .text,
                  password:
                      _passwordController
                          .text,
                );
              },
        child:
            provider.status ==
                    DecryptStatus
                        .decrypting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'DESCIFRAR',
                  ),
      ),
    );
  }

  Widget _buildResult(
    DecryptProvider provider,
  ) {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration:
          BoxDecoration(
        color:
            AppColors.surface,
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        border:
            Border.all(
          color:
              AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
        children: [
          const Text(
            'MENSAJE DESCIFRADO',
            style:
                TextStyle(
              color:
                  AppColors.green,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          SelectableText(
            provider
                .decryptedText!,
            style:
                const TextStyle(
              color:
                  AppColors.text,
              fontSize: 16,
              height: 1.5,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed:
                    provider.isBusy
                        ? null
                        : () {
                            widget
                                .controller
                                .copyDecryptedText();
                          },
                child:
                    const Text(
                  'COPY',
                ),
              ),

              OutlinedButton(
                onPressed:
                    provider.isBusy
                        ? null
                        : () async {
                            await widget
                                .controller
                                .saveDecryptedText();
                          },
                child:
                    const Text(
                  'SAVE',
                ),
              ),

              OutlinedButton(
                onPressed:
                    provider.isBusy
                        ? null
                        : () async {
                            await widget
                                .controller
                                .shareDecryptedText();
                          },
                child:
                    const Text(
                  'SHARE',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError(
    String message,
  ) {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(14),
      decoration:
          BoxDecoration(
        color:
            AppColors.errorBackground,
        borderRadius:
            BorderRadius.circular(
          12,
        ),
        border:
            Border.all(
          color:
              AppColors.error,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          const Icon(
            Icons
                .error_outline_rounded,
            color:
                AppColors.error,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              message,
              style:
                  const TextStyle(
                color:
                    AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}