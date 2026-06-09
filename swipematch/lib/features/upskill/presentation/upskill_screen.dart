import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../ai_coach/presentation/coach_panel.dart';
import '../../profile/domain/profile_model.dart';
import '../../profile/domain/profile_providers.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/ai_readiness_badge.dart';

class UpskillScreen extends ConsumerWidget {
  const UpskillScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (_, __) => const Center(
            child: Text('Failed to load profile'),
          ),
          data: (profile) => profile == null
              ? const Center(child: Text('No profile found'))
              : _UpskillContent(profile: profile),
        ),
      ),
    );
  }
}

class _UpskillContent extends StatelessWidget {
  const _UpskillContent({required this.profile});
  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final score = AiReadinessBadge.computeScore(profile.skills);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          const SizedBox(height: AppSpacing.lg),
          _AiReadinessCard(score: score, skills: profile.skills)
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0),
          const SizedBox(height: AppSpacing.lg),
          _SkillGapSection(profile: profile)
              .animate(delay: 100.ms)
              .fadeIn(duration: 400.ms),
          const SizedBox(height: AppSpacing.lg),
          _LearningPathSection(skills: profile.skills)
              .animate(delay: 200.ms)
              .fadeIn(duration: 400.ms),
          const SizedBox(height: AppSpacing.lg),
          _TrendingSkillsSection(profile: profile)
              .animate(delay: 300.ms)
              .fadeIn(duration: 400.ms),
          const SizedBox(height: AppSpacing.lg),
          const _AskCoachButton()
              .animate(delay: 400.ms)
              .fadeIn(duration: 400.ms),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Grow', style: AppTextStyles.headlineLg),
        const SizedBox(height: 4),
        Text(
          'Become who you\'re working toward — one skill at a time',
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _AiReadinessCard extends StatelessWidget {
  const _AiReadinessCard({required this.score, required this.skills});
  final double score;
  final List<String> skills;

  @override
  Widget build(BuildContext context) {
    final percent = (score * 100).round();
    final isReady = score >= 0.5;
    final missing = max(0, (4 - (score * 4).round()));

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.accent.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _ScoreRing(percent: percent, isReady: isReady),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'AI Readiness',
                      style: AppTextStyles.headlineSm,
                    ),
                    if (isReady) ...[
                      const SizedBox(width: AppSpacing.sm),
                      AiReadinessBadge(skills: skills, large: true),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  isReady
                      ? 'You\'re prepared for the AI era! Keep growing.'
                      : 'Add $missing more AI skill${missing == 1 ? '' : 's'} to unlock the AI Ready badge.',
                  style: AppTextStyles.bodyMd
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.percent, required this.isReady});
  final int percent;
  final bool isReady;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(
              value: percent / 100.0,
              strokeWidth: 6,
              backgroundColor: AppColors.card,
              valueColor: AlwaysStoppedAnimation(
                isReady ? AppColors.accent : AppColors.primary,
              ),
            ),
          ),
          Text(
            '$percent%',
            style: AppTextStyles.bodyMd.copyWith(
              fontWeight: FontWeight.w700,
              color: isReady ? AppColors.accent : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillGapSection extends StatelessWidget {
  const _SkillGapSection({required this.profile});
  final ProfileModel profile;

  static const _inDemandSkills = [
    'Python', 'Machine Learning', 'Prompt Engineering', 'Cloud (AWS/GCP)',
    'System Design', 'TypeScript', 'Kubernetes', 'Data Analysis',
    'LLM Integration', 'Vector Databases',
  ];

  @override
  Widget build(BuildContext context) {
    final skillsLower = profile.skills.map((s) => s.toLowerCase()).toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Skill Gap', style: AppTextStyles.headlineSm),
        const SizedBox(height: 4),
        Text(
          'Skills in demand vs. what you have',
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _inDemandSkills.map((skill) {
            final has = skillsLower
                .any((s) => s.contains(skill.toLowerCase().split(' ')[0]));
            return _SkillGapChip(label: skill, has: has);
          }).toList(),
        ),
      ],
    );
  }
}

class _SkillGapChip extends StatelessWidget {
  const _SkillGapChip({required this.label, required this.has});
  final String label;
  final bool has;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: has
            ? AppColors.accent.withValues(alpha: 0.12)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: has
              ? AppColors.accent.withValues(alpha: 0.4)
              : AppColors.card,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            has ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
            size: 13,
            color: has ? AppColors.accent : AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: has ? AppColors.accent : AppColors.textSecondary,
              fontWeight: has ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningItem {
  const _LearningItem({
    required this.emoji,
    required this.title,
    required this.desc,
    required this.hours,
  });
  final String emoji;
  final String title;
  final String desc;
  final String hours;
}

class _LearningPathSection extends StatelessWidget {
  const _LearningPathSection({required this.skills});
  final List<String> skills;

  static List<_LearningItem> _path(List<String> skills) {
    final lower = skills.map((s) => s.toLowerCase()).toList();
    final items = <_LearningItem>[];

    if (!lower.any((s) => s.contains('prompt') || s.contains('llm'))) {
      items.add(const _LearningItem(
        emoji: '✨',
        title: 'Prompt Engineering',
        desc: 'Learn to harness AI tools like a pro',
        hours: '2–3 hrs',
      ));
    }
    if (!lower.any((s) => s.contains('python'))) {
      items.add(const _LearningItem(
        emoji: '🐍',
        title: 'Python for AI',
        desc: 'The language of data science & ML',
        hours: '8–10 hrs',
      ));
    }
    if (!lower.any((s) => s.contains('cloud') || s.contains('aws') || s.contains('gcp'))) {
      items.add(const _LearningItem(
        emoji: '☁️',
        title: 'Cloud Fundamentals',
        desc: 'Deploy and scale AI applications',
        hours: '6–8 hrs',
      ));
    }
    if (!lower.any((s) => s.contains('machine learning') || s.contains('ml'))) {
      items.add(const _LearningItem(
        emoji: '🧠',
        title: 'Machine Learning Basics',
        desc: 'Understand how AI models work',
        hours: '12–15 hrs',
      ));
    }
    if (!lower.any((s) => s.contains('vector') || s.contains('rag'))) {
      items.add(const _LearningItem(
        emoji: '🔍',
        title: 'Vector Databases & RAG',
        desc: 'Build AI apps with long memory',
        hours: '4–5 hrs',
      ));
    }

    // Always add a system design item if list is short
    if (items.length < 2) {
      items.add(const _LearningItem(
        emoji: '🏗️',
        title: 'AI System Design',
        desc: 'Design scalable AI-first products',
        hours: '10–12 hrs',
      ));
    }

    return items.take(4).toList();
  }

  @override
  Widget build(BuildContext context) {
    final path = _path(skills);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Learning Path', style: AppTextStyles.headlineSm),
        const SizedBox(height: 4),
        Text(
          'Personalized to your current skills',
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),
        ...path.asMap().entries.map((e) =>
            _LearningCard(item: e.value, step: e.key + 1)
                .animate(delay: (e.key * 80).ms)
                .fadeIn(duration: 300.ms)
                .slideX(begin: 0.05, end: 0)),
      ],
    );
  }
}

class _LearningCard extends StatelessWidget {
  const _LearningCard({required this.item, required this.step});
  final _LearningItem item;
  final int step;

  void _openCoach(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: CoachPanel(
          matchId: 'upskill',
          initialPrompt:
              'How do I get started with ${item.title}? Give me a practical 30-day learning plan.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openCoach(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.card, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(item.emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.bodyMd
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.desc,
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.hours,
                  style:
                      AppTextStyles.label.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 2),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingSkillsSection extends StatelessWidget {
  const _TrendingSkillsSection({required this.profile});
  final ProfileModel profile;

  static const _trending = [
    '🔥 Cursor AI', '⚡ LangChain', '🧩 RAG', '🌐 Edge AI',
    '🤖 Agent Workflows', '📊 Fine-tuning', '🔐 AI Safety', '🎨 Diffusion Models',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trending This Week', style: AppTextStyles.headlineSm),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _trending.map((skill) {
            final cleanName = skill.replaceAll(RegExp(r'^\S+\s'), '');
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: CoachPanel(
                      matchId: 'upskill',
                      initialPrompt:
                          'Tell me about $cleanName — what it is, why it\'s trending, and how I can start using it in my career.',
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.card),
                ),
                child: Text(
                  skill,
                  style: AppTextStyles.label
                      .copyWith(color: AppColors.textPrimary),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _AskCoachButton extends StatelessWidget {
  const _AskCoachButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: const CoachPanel(matchId: 'upskill'),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.accent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Ask AI Coach About Your Gaps',
              style: AppTextStyles.bodyMd.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
