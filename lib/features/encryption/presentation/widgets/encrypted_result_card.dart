import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class EncryptedResultCard extends StatelessWidget {
  final String payload;
  final VoidCallback onCopy;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onHide;
  final bool isSaving;
  final bool isSharing;

  const EncryptedResultCard({
    super.key,
    required this.payload,
    required this.onCopy,
    required this.onSave,
    required this.onShare,
    required this.onHide,
    this.isSaving = false,
    this.isSharing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.green.withValues(alpha: 0.35),
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
                  'ENCRYPTION COMPLETE',
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

          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxHeight: 220,
            ),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: SingleChildScrollView(
              child: SelectableText(
                payload,
                style: const TextStyle(
                  color: AppColors.text,
                  fontFamily: 'monospace',
                  fontSize: 11,
                  height: 1.55,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCopy,
                  icon: const Icon(
                    Icons.copy_rounded,
                    size: 18,
                  ),
                  label: const Text('COPY'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isSaving ? null : onSave,
                  icon: isSaving
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
                    isSaving ? 'SAVING...' : 'SAVE',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isSharing ? null : onShare,
                  icon: isSharing
                      ? const SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.share_outlined,
                          size: 18,
                        ),
                  label: Text(
                    isSharing ? 'SHARING...' : 'SHARE',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onHide,
                  icon: const Icon(
                    Icons.image_outlined,
                    size: 18,
                  ),
                  label: const Text('HIDE'),
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
}