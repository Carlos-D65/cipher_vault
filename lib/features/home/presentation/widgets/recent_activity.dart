import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ACTIVIDAD RECIENTE',
          style: TextStyle(
            color: AppColors.subtle,
            fontSize: 8,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.green.withValues(
                  alpha: 0.08,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.green,
                size: 12,
              ),
            ),
            const SizedBox(width: 7),
            const Expanded(
              child: Text(
                'Mensaje cifrado hace 12 min con AES-256',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 8,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}