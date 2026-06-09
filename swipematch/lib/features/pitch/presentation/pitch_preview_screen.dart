import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../data/pitch_repository.dart';
import '../data/pitch_validator.dart';
import '../../profile/domain/profile_providers.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';

/// Confirm-or-discard preview. Used by both record and upload paths.
///
/// - If [file] is provided, this is a local-file preview pre-upload.
/// - If [remoteUrl] is provided, this is a read-only player for an
///   already-published pitch (e.g. employer viewing a candidate).
class PitchPreviewScreen extends HookConsumerWidget {
  const PitchPreviewScreen({
    super.key,
    this.profileId,
    this.file,
    this.remoteUrl,
    this.readOnly = false,
  }) : assert(file != null || remoteUrl != null,
            'PitchPreviewScreen needs a file or a remote URL');

  final String? profileId;
  final File? file;
  final String? remoteUrl;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerState = useState<VideoPlayerController?>(null);
    final uploading = useState(false);
    final error = useState<String?>(null);

    useEffect(() {
      final c = file != null
          ? VideoPlayerController.file(file!)
          : VideoPlayerController.networkUrl(Uri.parse(remoteUrl!));
      c.initialize().then((_) {
        try {
          if (file != null) PitchValidator.validateDuration(c.value.duration);
          controllerState.value = c;
          c.setLooping(true);
          c.play();
        } catch (e) {
          error.value = e.toString();
        }
      }).catchError((_) {
        error.value = 'Could not load video.';
      });
      return () => c.dispose();
    }, const []);

    Future<void> confirm() async {
      if (file == null || profileId == null) return;
      uploading.value = true;
      error.value = null;
      try {
        await ref
            .read(pitchRepositoryProvider)
            .uploadAndPublish(profileId: profileId!, file: file!);
        ref.invalidate(currentProfileProvider);
        if (context.mounted) {
          Navigator.of(context).popUntil((r) => r.isFirst);
        }
      } catch (e) {
        error.value = e.toString();
      } finally {
        uploading.value = false;
      }
    }

    final ctrl = controllerState.value;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  Text(
                    readOnly ? 'Pitch' : 'Preview',
                    style: AppTextStyles.headlineSm
                        .copyWith(color: Colors.white),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: ctrl != null && ctrl.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: ctrl.value.aspectRatio,
                        child: VideoPlayer(ctrl),
                      )
                    : const CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
            if (error.value != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text(
                  error.value!,
                  style:
                      AppTextStyles.bodyMd.copyWith(color: AppColors.danger),
                  textAlign: TextAlign.center,
                ),
              ),
            if (!readOnly)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: uploading.value
                            ? null
                            : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white24),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Retake',
                          style: AppTextStyles.buttonText
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Use this',
                        isLoading: uploading.value,
                        onPressed: uploading.value ? null : confirm,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
