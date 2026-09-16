import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/cipher_vault_bottom_navigation.dart';
import '../widgets/home_header.dart';
import '../widgets/protection_layer_card.dart';
import '../widgets/recent_activity.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (
                  context,
                  constraints,
                ) {
                  final horizontalPadding =
                      constraints.maxWidth < 360
                          ? 16.0
                          : 20.0;

                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      14,
                      horizontalPadding,
                      18,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 520,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const HomeHeader(),

                            const SizedBox(height: 16),

                            ProtectionLayerCard(
                              title:
                                  'CAPA 1: CRIPTOGRAFÍA',
                              subtitle:
                                  'INDESTRUCTIBLE',
                              icon:
                                  Icons.shield_outlined,
                              iconColor:
                                  AppColors.cyan,
                              description:
                                  'Encripta tus mensajes y datos confidenciales '
                                  'con AES-GCM 256. El estándar militar absoluto.',
                              child: LayoutBuilder(
                                builder: (
                                  context,
                                  constraints,
                                ) {
                                  final narrow =
                                      constraints.maxWidth <
                                          300;

                                  if (narrow) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .stretch,
                                      children: [
                                        _PrimaryButton(
                                          label:
                                              'Proteger información',
                                          onPressed: () {
                                            Navigator
                                                .pushNamed(
                                              context,
                                              '/protect',
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        _SecondaryButton(
                                          label:
                                              'Descifrar',
                                          onPressed: () {
                                            Navigator
                                                .pushNamed(
                                              context,
                                              '/decrypt',
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  }

                                  return Row(
                                    children: [
                                      Expanded(
                                        child:
                                            _PrimaryButton(
                                          label:
                                              'Proteger\ninformación',
                                          onPressed: () {
                                            Navigator
                                                .pushNamed(
                                              context,
                                              '/protect',
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child:
                                            _SecondaryButton(
                                          label:
                                              'Descifrar',
                                          onPressed: () {
                                            Navigator
                                                .pushNamed(
                                              context,
                                              '/decrypt',
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 10),

                            ProtectionLayerCard(
                              title:
                                  'CAPA 2: OCULTAR (ESTEG)',
                              subtitle:
                                  'SEGUNDA CAPA OPCIONAL',
                              icon: Icons
                                  .visibility_off_outlined,
                              iconColor:
                                  AppColors.green,
                              description:
                                  'Esconde información cifrada dentro de una '
                                  'imagen portadora sin alterar su aspecto visible.',
                              child: _SecondaryButton(
                                label:
                                    'Explorar Ocultamiento',
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/hide',
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            const RecentActivity(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const CipherVaultBottomNavigation(
              currentIndex: 0,
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 41,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cyan,
          foregroundColor: AppColors.background,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 8.5,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _SecondaryButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 41,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          side: const BorderSide(
            color: AppColors.border,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 8.5,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}