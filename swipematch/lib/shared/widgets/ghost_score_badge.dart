import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Public ghost-score chip rendered on company surfaces.
///
/// Briefing §06: "After a bilateral match, a 72-hour response countdown starts.
/// If the employer doesn't reply, a 'ghosted' stat increments on their public
/// company profile. This stat is visible to all candidates."
///
/// Color thresholds:
///   ≥ 90  → accent green (good actor)
///   ≥ 70  → matchGold (warning)
///   < 70  → danger red (chronic ghoster)
class GhostScoreBadge extends StatelessWidget {
  const GhostScoreBadge({
    super.key,
    required this.score,
    this.compact = false,
  });

  final int score;
  final bool compact;

  Color get _color {
    if (score >= 90) return AppColors.accent;
    if (score >= 70) return AppColors.matchGold;
    return AppColors.danger;
  }

  String get _label {
    if (score >= 90) return 'Responsive';
    if (score >= 70) return 'Sometimes ghosts';
    return 'Ghoster';
  }

  @override
  Widget build(BuildContext context) {
    final padH = compact ? 6.0 : 8.0;
    final padV = compact ? 3.0 : 4.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            score >= 70 ? '👻' : '👻💀',
            style: TextStyle(fontSize: compact ? 10 : 12),
          ),
          const SizedBox(width: 4),
          Text(
            compact ? '$score' : '$score · $_label',
            style: AppTextStyles.label.copyWith(
              color: _color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pipeline-card ghost countdown. Shows remaining hours of the 72h window
/// when no reply yet, switches to "Ghosted" once `ghostedAt` is set.
class GhostCountdownChip extends StatelessWidget {
  const GhostCountdownChip({
    super.key,
    required this.matchCreatedAt,
    required this.firstResponseAt,
    required this.ghostedAt,
  });

  final DateTime matchCreatedAt;
  final DateTime? firstResponseAt;
  final DateTime? ghostedAt;

  @override
  Widget build(BuildContext context) {
    if (firstResponseAt != null) return const SizedBox.shrink();

    if (ghostedAt != null) {
      return _chip(
        color: AppColors.danger,
        icon: '👻',
        text: 'Ghosted',
      );
    }

    final elapsed = DateTime.now().difference(matchCreatedAt);
    final remaining = const Duration(hours: 72) - elapsed;
    if (remaining.isNegative) {
      return _chip(color: AppColors.danger, icon: '👻', text: 'Ghosted');
    }

    final hoursLeft = remaining.inHours;
    final urgent = hoursLeft <= 24;
    return _chip(
      color: urgent ? AppColors.danger : AppColors.matchGold,
      icon: urgent ? '⏰' : '🕐',
      text: '${hoursLeft}h left',
    );
  }

  Widget _chip({required Color color, required String icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 3),
          Text(
            text,
            style: AppTextStyles.label.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
