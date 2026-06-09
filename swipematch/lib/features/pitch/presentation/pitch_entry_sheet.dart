import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../data/pitch_validator.dart';
import 'pitch_preview_screen.dart';
import 'pitch_recorder_screen.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';

/// Bottom sheet that lets the user pick how to capture their 60-second pitch:
/// record from inside the app, or upload an existing video from the gallery.
class PitchEntrySheet extends ConsumerWidget {
  const PitchEntrySheet({super.key, required this.profileId});

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Your 60-second pitch', style: AppTextStyles.headlineSm),
            const SizedBox(height: 4),
            Text(
              'Skip the CV. Tell employers who you are in one minute.',
              style: AppTextStyles.bodyMd,
            ),
            const SizedBox(height: AppSpacing.lg),
            _ActionTile(
              icon: Icons.videocam_rounded,
              title: 'Record now',
              subtitle: 'Use your camera. 60-second cap.',
              color: AppColors.primary,
              onTap: () async {
                Navigator.of(context).pop();
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PitchRecorderScreen(profileId: profileId),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            _ActionTile(
              icon: Icons.upload_file_rounded,
              title: 'Upload existing',
              subtitle: 'Pick an mp4 / mov from your library.',
              color: AppColors.accent,
              onTap: () => _pickFromLibrary(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromLibrary(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: PitchValidator.maxDuration,
    );
    if (picked == null) {
      if (context.mounted) Navigator.of(context).pop();
      return;
    }

    if (!context.mounted) return;
    Navigator.of(context).pop();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PitchPreviewScreen(
          profileId: profileId,
          file: File(picked.path),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(subtitle, style: AppTextStyles.bodyMd),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
