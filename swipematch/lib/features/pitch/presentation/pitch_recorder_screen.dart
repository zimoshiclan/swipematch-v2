import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'pitch_preview_screen.dart';
import '../data/pitch_validator.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';

/// In-app camera recorder with a hard 60-second cap.
///
/// Lifecycle:
///  - On mount: pick the front camera, initialize controller.
///  - Tap record: start recording, start countdown ticker.
///  - Auto-stop at 60s; or user-stop earlier.
///  - On stop: push PitchPreviewScreen with the captured file.
class PitchRecorderScreen extends HookConsumerWidget {
  const PitchRecorderScreen({super.key, required this.profileId});

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerState = useState<CameraController?>(null);
    final error = useState<String?>(null);
    final initializing = useState(true);
    final recording = useState(false);
    final secondsLeft = useState<int>(PitchValidator.maxDuration.inSeconds);
    final timerRef = useRef<Timer?>(null);

    useEffect(() {
      _setupCamera(controllerState, initializing, error);
      return () {
        timerRef.value?.cancel();
        controllerState.value?.dispose();
      };
    }, const []);

    Future<void> stopRecording() async {
      final ctrl = controllerState.value;
      if (ctrl == null || !ctrl.value.isRecordingVideo) return;
      timerRef.value?.cancel();
      try {
        final file = await ctrl.stopVideoRecording();
        recording.value = false;
        if (!context.mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => PitchPreviewScreen(
              profileId: profileId,
              file: File(file.path),
            ),
          ),
        );
      } catch (e) {
        error.value = 'Recording failed: $e';
        recording.value = false;
      }
    }

    Future<void> startRecording() async {
      final ctrl = controllerState.value;
      if (ctrl == null || !ctrl.value.isInitialized) return;
      try {
        await ctrl.startVideoRecording();
        recording.value = true;
        secondsLeft.value = PitchValidator.maxDuration.inSeconds;

        timerRef.value = Timer.periodic(const Duration(seconds: 1), (t) {
          secondsLeft.value -= 1;
          if (secondsLeft.value <= 0) {
            t.cancel();
            stopRecording();
          }
        });
      } catch (e) {
        error.value = 'Could not start recording: $e';
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (controllerState.value != null &&
                controllerState.value!.value.isInitialized)
              Positioned.fill(
                child: AspectRatio(
                  aspectRatio: controllerState.value!.value.aspectRatio,
                  child: CameraPreview(controllerState.value!),
                ),
              ),
            if (initializing.value)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            if (error.value != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        error.value!,
                        style: AppTextStyles.bodyMd
                            .copyWith(color: AppColors.danger),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextButton(
                        onPressed: openAppSettings,
                        child: Text(
                          'Open Settings',
                          style: AppTextStyles.bodyMd
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Top bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    if (recording.value)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.fiber_manual_record,
                                color: Colors.white, size: 10),
                            const SizedBox(width: 4),
                            Text(
                              '${secondsLeft.value}s',
                              style: AppTextStyles.bodyMd.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Bottom record button
            Positioned(
              bottom: AppSpacing.xl,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (recording.value) {
                      stopRecording();
                    } else {
                      startRecording();
                    }
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Center(
                      child: Container(
                        width: recording.value ? 32 : 64,
                        height: recording.value ? 32 : 64,
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          borderRadius:
                              BorderRadius.circular(recording.value ? 6 : 32),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setupCamera(
    ValueNotifier<CameraController?> controller,
    ValueNotifier<bool> initializing,
    ValueNotifier<String?> error,
  ) async {
    // Request camera and microphone permissions before accessing hardware.
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (!cameraStatus.isGranted || !micStatus.isGranted) {
      error.value =
          'Camera and microphone access are required. Please enable them in Settings.';
      initializing.value = false;
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        error.value = 'No camera available on this device.';
        initializing.value = false;
        return;
      }
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final ctrl = CameraController(
        front,
        ResolutionPreset.medium,
        enableAudio: true,
      );
      await ctrl.initialize();
      controller.value = ctrl;
      initializing.value = false;
    } catch (e) {
      error.value = 'Camera permission denied or unavailable.';
      initializing.value = false;
    }
  }
}
