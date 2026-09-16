import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.cyan,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
                Icons.lock_outline,
                color: AppColors.cyan,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'CipherVault',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 28,
                minHeight: 28,
              ),
              icon: const Icon(
                Icons.settings_outlined,
                size: 15,
                color: AppColors.subtle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Protege lo que importa.',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 21,
            fontWeight: FontWeight.w700,
            height: 1.1,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Frontera matemática indestructible para tus datos.\n'
          'Elige tu nivel de protección.',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 9.5,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}