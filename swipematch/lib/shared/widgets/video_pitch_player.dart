import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:video_player/video_player.dart';

import '../theme/app_colors.dart';

/// Lightweight looping network-video player for the intro-video reels feed.
///
/// Plays only when [isActive] (the current page in the PageView). Starts muted
/// so autoplay is allowed on web; tap toggles play/pause, the speaker button
/// toggles sound. Fills the available space with a cover fit.
class VideoPitchPlayer extends HookWidget {
  const VideoPitchPlayer({
    super.key,
    required this.url,
    required this.isActive,
  });

  final String url;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final controller = useState<VideoPlayerController?>(null);
    final muted = useState(true);
    final ready = useState(false);

    useEffect(() {
      final c = VideoPlayerController.networkUrl(Uri.parse(url));
      var disposed = false;
      c.initialize().then((_) {
        if (disposed) return;
        c.setLooping(true);
        c.setVolume(0);
        controller.value = c;
        ready.value = true;
        if (isActive) c.play();
      }).catchError((_) {/* leave spinner; reels skips broken videos */});
      return () {
        disposed = true;
        c.dispose();
      };
    }, [url]);

    // React to becoming the active page.
    useEffect(() {
      final c = controller.value;
      if (c != null && c.value.isInitialized) {
        isActive ? c.play() : c.pause();
      }
      return null;
    }, [isActive, ready.value]);

    final c = controller.value;

    if (c == null || !c.value.isInitialized) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return GestureDetector(
      onTap: () => c.value.isPlaying ? c.pause() : c.play(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: c.value.size.width,
              height: c.value.size.height,
              child: VideoPlayer(c),
            ),
          ),
          // Mute / unmute toggle
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {
                muted.value = !muted.value;
                c.setVolume(muted.value ? 0 : 1);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  muted.value
                      ? Icons.volume_off_rounded
                      : Icons.volume_up_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
