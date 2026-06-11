import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../features/profile/domain/profile_model.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_styles.dart';
import '../../../../shared/widgets/ai_readiness_badge.dart';

class PersonSwipeCard extends StatelessWidget {
  const PersonSwipeCard({
    super.key,
    required this.person,
    this.horizontalThreshold = 0,
    this.verticalThreshold = 0,
  });

  final ProfileModel person;
  final int horizontalThreshold;
  final int verticalThreshold;

  // Deterministic gradient from name — each person gets their own colour
  static const _gradients = [
    [Color(0xFF6C63FF), Color(0xFF4A47E0)],
    [Color(0xFF00C9A7), Color(0xFF0095AB)],
    [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
    [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    [Color(0xFF0EA5E9), Color(0xFF0369A1)],
    [Color(0xFF10B981), Color(0xFF047857)],
    [Color(0xFFF59E0B), Color(0xFFB45309)],
    [Color(0xFFEC4899), Color(0xFFBE185D)],
  ];

  List<Color> _gradientFor(String name) {
    final idx = name.codeUnits.fold(0, (a, b) => a + b) % _gradients.length;
    return _gradients[idx];
  }

  @override
  Widget build(BuildContext context) {
    final initials = person.name.isNotEmpty
        ? person.name.split(' ').take(2).map((w) => w[0]).join().toUpperCase()
        : '?';
    final grad = _gradientFor(person.name);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Top: gradient hero ──────────────────────────────
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: grad,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Avatar circle
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  initials,
                                  style: AppTextStyles.display.copyWith(
                                      color: Colors.white, fontSize: 36),
                                ),
                              ),
                            ).animate().scale(
                                begin: const Offset(0.8, 0.8),
                                duration: 400.ms,
                                curve: Curves.elasticOut),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              person.name,
                              style: AppTextStyles.headlineSm.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (person.headline != null &&
                                person.headline!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                person.headline!,
                                style: AppTextStyles.label.copyWith(
                                    color: Colors.white.withValues(alpha: 0.85)),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      // AI badge top-right
                      if (person.skills.isNotEmpty)
                        Positioned(
                          top: AppSpacing.sm,
                          right: AppSpacing.sm,
                          child: AiReadinessBadge(skills: person.skills, large: false),
                        ),
                      // Video pitch badge top-left
                      if (person.videoPitchUrl != null)
                        Positioned(
                          top: AppSpacing.sm,
                          left: AppSpacing.sm,
                          child: _PitchBadge(),
                        ),
                      // Serendipity wildcard badge bottom-left of hero
                      if (person.isSerendipity)
                        Positioned(
                          bottom: AppSpacing.sm,
                          left: AppSpacing.sm,
                          child: _SerendipityBadge(),
                        ),
                    ],
                  ),
                ),
              ),

              // ── Bottom: context info ────────────────────────────
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (person.workingToward != null &&
                          person.workingToward!.isNotEmpty) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.rocket_launch_rounded,
                                size: 14, color: grad[0]),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                person.workingToward!,
                                style: AppTextStyles.bodyMd.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                      if (person.skills.isNotEmpty) ...[
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: person.skills
                              .take(4)
                              .map((s) => _MiniChip(label: s, color: grad[0]))
                              .toList(),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                      ],
                      if (person.workValues.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: person.workValues
                              .take(3)
                              .map((v) => _MiniChip(
                                    label: v,
                                    color: AppColors.accent,
                                    outlined: true,
                                  ))
                              .toList(),
                        ),
                      if (person.connectionIntents.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: person.connectionIntents
                              .take(3)
                              .map((i) => _MiniChip(
                                    label: AppConstants
                                            .connectionIntents[i] ??
                                        i,
                                    color: grad[1],
                                  ))
                              .toList(),
                        ),
                      ],
                      const Spacer(),
                      Row(
                        children: [
                          if (_location(person) != null) ...[
                            const Icon(Icons.place_outlined,
                                size: 13, color: AppColors.textSecondary),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                _location(person)!,
                                style: AppTextStyles.label.copyWith(
                                    color: AppColors.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Spacer(),
                          ],
                          if (person.experienceYears != null)
                            Text(
                              '${person.experienceYears} yrs',
                              style: AppTextStyles.label
                                  .copyWith(color: AppColors.textSecondary),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Swipe direction overlays ────────────────────────────
          if (horizontalThreshold > 20)
            Positioned(
              top: AppSpacing.lg,
              left: AppSpacing.lg,
              child: _DirectionBadge(label: 'Connect', color: AppColors.accent),
            ),
          if (horizontalThreshold < -20)
            Positioned(
              top: AppSpacing.lg,
              right: AppSpacing.lg,
              child: _DirectionBadge(label: 'Pass', color: AppColors.surface),
            ),
          if (verticalThreshold < -20)
            Positioned(
              top: AppSpacing.lg,
              left: 0,
              right: 0,
              child: Center(
                child: _DirectionBadge(label: 'Super\nConnect', color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}

String? _location(ProfileModel p) {
  final parts = [p.city, p.country]
      .where((s) => s != null && s.trim().isNotEmpty)
      .map((s) => s!.trim())
      .toList();
  return parts.isEmpty ? null : parts.join(', ');
}

class _PitchBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.play_circle_rounded, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text('Pitch', style: AppTextStyles.label.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

class _SerendipityBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome_rounded,
              color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text('Serendipity',
              style: AppTextStyles.label.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label, required this.color, this.outlined = false});
  final String label;
  final Color color;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: outlined
            ? Border.all(color: color.withValues(alpha: 0.4))
            : null,
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _DirectionBadge extends StatelessWidget {
  const _DirectionBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyMd.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
