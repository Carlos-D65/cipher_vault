import 'package:flutter/material.dart';

import '../../../../core/security/models/encryption_algorithm.dart';
import '../../../../core/theme/app_theme.dart';

class EncryptionAlgorithmSelector extends StatelessWidget {
  final EncryptionAlgorithm value;
  final ValueChanged<EncryptionAlgorithm> onChanged;
  final bool enabled;

  const EncryptionAlgorithmSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ALGORITHM',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<EncryptionAlgorithm>(
              value: value,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              dropdownColor: AppColors.surface,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.cyan,
              ),
              onChanged: enabled
                  ? (value) {
                      if (value != null) {
                        onChanged(value);
                      }
                    }
                  : null,
              items: EncryptionAlgorithm.values
                  .map(
                    (algorithm) =>
                        DropdownMenuItem<EncryptionAlgorithm>(
                      value: algorithm,
                      child: Text(
                        algorithm.name,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}