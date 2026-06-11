import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../router/app_router.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/utils/haptics.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/skill_tag.dart';
import '../../profile/domain/profile_providers.dart';
import '../domain/onboarding_providers.dart';

class CandidateOnboardingScreen extends HookConsumerWidget {
  const CandidateOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final state = ref.watch(onboardingNotifierProvider);
    final notifier = ref.read(onboardingNotifierProvider.notifier);
    final isLoading = useState(false);

    // Page 2 (Becoming) local state — not in OnboardingState
    final workingTowardCtrl = useTextEditingController();
    final selectedWorkValues = useState<List<String>>([]);

    // 7 pages: Persona | Skills | Becoming | Status | Location+Intent | Work prefs | AI Readiness
    const totalPages = 7;

    Future<void> advance() async {
      AppHaptics.buttonTap();
      final profileAsync = ref.read(currentProfileProvider);
      final profileId = profileAsync.valueOrNull?.id;

      // Save becoming data when leaving page 2
      if (state.currentPage == 2 && profileId != null) {
        await notifier.saveBecoming(
          profileId,
          workingToward: workingTowardCtrl.text.trim(),
          workValues: selectedWorkValues.value,
        );
      } else if (profileId != null) {
        await notifier.savePageToSupabase(profileId, state.currentPage);
      }

      if (state.currentPage < totalPages - 1) {
        notifier.nextPage();
        pageController.animateToPage(
          state.currentPage + 1,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOutCubic,
        );
      } else {
        isLoading.value = true;
        try {
          if (profileId != null) await notifier.completeOnboarding(profileId);
          if (context.mounted) context.go(AppRoutes.home);
        } finally {
          isLoading.value = false;
        }
      }
    }

    Future<void> skipForNow() async {
      AppHaptics.buttonTap();
      final profileId = ref.read(currentProfileProvider).valueOrNull?.id;
      if (profileId != null) {
        await notifier.savePageToSupabase(profileId, state.currentPage);
      }
      if (context.mounted) context.go(AppRoutes.home);
    }

    void goBack() {
      AppHaptics.buttonTap();
      notifier.prevPage();
      pageController.animateToPage(
        state.currentPage - 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }

    bool canAdvance() {
      return switch (state.currentPage) {
        0 => state.persona != null,
        1 => state.skills.length >= AppConstants.minSkillsRequired,
        2 => true, // Becoming is optional
        3 => state.status != null,
        4 => state.connectionIntents.isNotEmpty,
        5 => state.workStyle != null,
        6 => state.aiReadinessAnswers.length ==
            AppConstants.aiReadinessQuestions.length,
        _ => false,
      };
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              currentPage: state.currentPage,
              totalPages: totalPages,
              onBack: state.currentPage > 0 ? goBack : null,
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // 0 — Persona
                  _PagePersona(
                    selected: state.persona,
                    onSelect: notifier.setPersona,
                  ),
                  // 1 — Skills
                  _Page2Skills(
                    skills: state.skills,
                    onAdd: notifier.addSkill,
                    onRemove: notifier.removeSkill,
                  ),
                  // 2 — Becoming (NEW)
                  _Page3Becoming(
                    workingTowardCtrl: workingTowardCtrl,
                    selectedValues: selectedWorkValues.value,
                    onToggleValue: (v) {
                      final list = List<String>.from(selectedWorkValues.value);
                      if (list.contains(v)) {
                        list.remove(v);
                      } else if (list.length < 4) {
                        list.add(v);
                      }
                      selectedWorkValues.value = list;
                    },
                  ),
                  // 3 — Status (reframed)
                  _Page4Status(
                    selected: state.status,
                    onSelect: notifier.setStatus,
                  ),
                  // 4 — Location + connection intent
                  _Page5Region(
                    intents: state.connectionIntents,
                    city: state.city,
                    country: state.country,
                    onToggleIntent: notifier.toggleConnectionIntent,
                    onCity: notifier.setCity,
                    onCountry: notifier.setCountry,
                  ),
                  // 5 — Work preferences
                  _Page6WorkStyle(
                    workStyle: state.workStyle,
                    cultureTags: state.cultureTags,
                    jobSearchTimeline: state.jobSearchTimeline,
                    onWorkStyle: notifier.setWorkStyle,
                    onCultureTag: notifier.toggleCultureTag,
                    onTimeline: notifier.setTimeline,
                  ),
                  // 6 — AI Readiness
                  _Page7AiReadiness(
                    answers: state.aiReadinessAnswers,
                    onAnswer: notifier.setAiReadinessAnswer,
                  ),
                ],
              ),
            ),
            _Footer(
              canAdvance: canAdvance(),
              isLastPage: state.currentPage == totalPages - 1,
              isLoading: isLoading.value,
              onAdvance: advance,
              onSkip: skipForNow,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// Header
// ──────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  const _Header({
    required this.currentPage,
    required this.totalPages,
    this.onBack,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
      child: Row(
        children: [
          if (onBack != null)
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary, size: 18),
              ),
            )
          else
            const SizedBox(width: 40),
          const Spacer(),
          Row(
            children: List.generate(totalPages, (i) {
              final isActive = i == currentPage;
              final isDone = i < currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary
                      : isDone
                          ? AppColors.primary.withValues(alpha: 0.4)
                          : AppColors.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// Footer
// ──────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  const _Footer({
    required this.canAdvance,
    required this.isLastPage,
    required this.isLoading,
    required this.onAdvance,
    required this.onSkip,
  });

  final bool canAdvance;
  final bool isLastPage;
  final bool isLoading;
  final VoidCallback onAdvance;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            label: isLastPage ? 'Join the Community' : 'Continue',
            onPressed: canAdvance ? onAdvance : null,
            isLoading: isLoading,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: onSkip,
            child: Text(
              AppConstants.onboardingSkipLabel,
              style: AppTextStyles.bodyMd
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// Page 1 — Persona (who are you?)
// ──────────────────────────────────────────────────────────
class _PagePersona extends StatelessWidget {
  const _PagePersona({required this.selected, required this.onSelect});

  final String? selected;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return _PageWrapper(
      title: 'Who are you?',
      subtitle: 'This is for everyone — pick what fits you best',
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: AppConstants.personas.map((persona) {
          final isSelected = selected == persona;
          return GestureDetector(
            onTap: () => onSelect(persona),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                ),
              ),
              child: Text(
                persona,
                style: AppTextStyles.bodyMd.copyWith(
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ).animate(delay: (AppConstants.personas.indexOf(persona) * 40).ms)
                .fadeIn(duration: 300.ms)
                .scale(begin: const Offset(0.9, 0.9)),
          );
        }).toList(),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// Page 2 — Skills
// ──────────────────────────────────────────────────────────
class _Page2Skills extends HookWidget {
  const _Page2Skills({
    required this.skills,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> skills;
  final void Function(String) onAdd;
  final void Function(String) onRemove;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    void add() {
      final text = controller.text.trim();
      if (text.isNotEmpty) {
        onAdd(text);
        controller.clear();
      }
    }

    return _PageWrapper(
      title: 'What do you bring?',
      subtitle: 'Add at least 3 — anything counts',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => add(),
                  style: AppTextStyles.bodyLg,
                  decoration:
                      const InputDecoration(hintText: 'e.g. React, Figma, Public Speaking…'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: add,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
          if (skills.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: skills
                  .map((s) => _RemovableSkill(
                        label: s,
                        onRemove: () => onRemove(s),
                      ))
                  .toList(),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text('Popular skills', style: AppTextStyles.bodyMd),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: AppConstants.popularSkills
                .where((s) => !skills.contains(s))
                .take(10)
                .map((s) => GestureDetector(
                      onTap: () => onAdd(s),
                      child: SkillTag(label: '+ $s'),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _RemovableSkill extends StatelessWidget {
  const _RemovableSkill({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: AppTextStyles.label.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.w600)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child:
                const Icon(Icons.close_rounded, size: 14, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// Page 3 — Becoming (NEW)
// ──────────────────────────────────────────────────────────

const _kWorkValues = [
  'Impact-driven',
  'Honest culture',
  'Continuous learning',
  'Work-life balance',
  'Mission-driven',
  'Flat hierarchy',
  'Mentorship',
  'Autonomy',
  'Collaboration',
  'Innovation',
  'Purpose over pay',
  'Fast-paced',
];

class _Page3Becoming extends StatelessWidget {
  const _Page3Becoming({
    required this.workingTowardCtrl,
    required this.selectedValues,
    required this.onToggleValue,
  });

  final TextEditingController workingTowardCtrl;
  final List<String> selectedValues;
  final void Function(String) onToggleValue;

  @override
  Widget build(BuildContext context) {
    return _PageWrapper(
      title: 'What are you\nbuilding toward?',
      subtitle: 'Optional — but this is what sets you apart',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: workingTowardCtrl,
            style: AppTextStyles.bodyMd,
            maxLines: 2,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText:
                  'e.g. Leading a product team, moving into climate tech, building something of my own…',
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('What matters most to you at work?',
              style: AppTextStyles.bodyMd),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Pick up to 4',
            style:
                AppTextStyles.label.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _kWorkValues.asMap().entries.map((entry) {
              final v = entry.value;
              final selected = selectedValues.contains(v);
              return GestureDetector(
                onTap: () => onToggleValue(v),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.card,
                    ),
                  ),
                  child: Text(
                    v,
                    style: AppTextStyles.label.copyWith(
                      color: selected
                          ? Colors.white
                          : AppColors.textSecondary,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ).animate(delay: (entry.key * 30).ms).fadeIn(duration: 250.ms),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// Page 4 — Status (reframed from job-search)
// ──────────────────────────────────────────────────────────
class _Page4Status extends StatelessWidget {
  const _Page4Status({required this.selected, required this.onSelect});

  final String? selected;
  final void Function(String) onSelect;

  static const _options = [
    (
      value: 'actively_looking',
      label: 'Ready to move',
      sub: 'I\'m actively looking and want to start soon',
      icon: Icons.rocket_launch_rounded,
    ),
    (
      value: 'open',
      label: 'Open to the right thing',
      sub: 'I\'ll consider an opportunity that aligns with my values',
      icon: Icons.explore_rounded,
    ),
    (
      value: 'investing_in_growth',
      label: 'Investing in growth',
      sub: 'I\'m focused on building skills and connections right now',
      icon: Icons.trending_up_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _PageWrapper(
      title: 'Where are you\nright now?',
      subtitle: 'This shapes how you appear to opportunities',
      child: Column(
        children: _options.asMap().entries.map((entry) {
          final opt = entry.value;
          final isSelected = selected == opt.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: GestureDetector(
              onTap: () => onSelect(opt.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(opt.icon,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 24),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(opt.label,
                              style: AppTextStyles.bodyLg.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              )),
                          const SizedBox(height: 2),
                          Text(opt.sub,
                              style: AppTextStyles.bodyMd.copyWith(
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.primary, size: 20),
                  ],
                ),
              ),
            ).animate(delay: (entry.key * 80).ms).fadeIn(duration: 300.ms).slideX(begin: 0.05, end: 0),
          );
        }).toList(),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// Page 5 — Location + connection intent
// ──────────────────────────────────────────────────────────
class _Page5Region extends HookWidget {
  const _Page5Region({
    required this.intents,
    required this.city,
    required this.country,
    required this.onToggleIntent,
    required this.onCity,
    required this.onCountry,
  });

  final List<String> intents;
  final String? city;
  final String? country;
  final void Function(String) onToggleIntent;
  final void Function(String) onCity;
  final void Function(String) onCountry;

  @override
  Widget build(BuildContext context) {
    final cityCtrl = useTextEditingController(text: city ?? '');
    final countryCtrl = useTextEditingController(text: country ?? '');

    return _PageWrapper(
      title: 'Where are you &\nwhat are you after?',
      subtitle: 'We use this to introduce you to the right people nearby',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: cityCtrl,
                  style: AppTextStyles.bodyMd,
                  textInputAction: TextInputAction.next,
                  onChanged: onCity,
                  decoration: const InputDecoration(hintText: 'City'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: countryCtrl,
                  style: AppTextStyles.bodyMd,
                  textInputAction: TextInputAction.done,
                  onChanged: onCountry,
                  decoration: const InputDecoration(hintText: 'Country'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('What kind of connections are you looking for?',
              style: AppTextStyles.bodyMd),
          const SizedBox(height: AppSpacing.xs),
          Text('Pick any — "Surprise me" mixes in serendipitous matches',
              style:
                  AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: AppConstants.connectionIntents.entries.map((entry) {
              final selected = intents.contains(entry.key);
              return GestureDetector(
                onTap: () => onToggleIntent(entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.card,
                    ),
                  ),
                  child: Text(
                    entry.value,
                    style: AppTextStyles.label.copyWith(
                      color:
                          selected ? Colors.white : AppColors.textSecondary,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// Page 6 — Work style + culture + timeline
// ──────────────────────────────────────────────────────────
class _Page6WorkStyle extends StatelessWidget {
  const _Page6WorkStyle({
    required this.workStyle,
    required this.cultureTags,
    required this.jobSearchTimeline,
    required this.onWorkStyle,
    required this.onCultureTag,
    required this.onTimeline,
  });

  final String? workStyle;
  final List<String> cultureTags;
  final String? jobSearchTimeline;
  final void Function(String) onWorkStyle;
  final void Function(String) onCultureTag;
  final void Function(String) onTimeline;

  static const _styles = ['remote', 'hybrid', 'on_site'];
  static const _styleLabels = ['Remote', 'Hybrid', 'On-site'];
  static const _timelines = [
    (value: '1_month', label: '1 month'),
    (value: '3_months', label: '3 months'),
    (value: '6_months', label: '6 months'),
    (value: 'exploring', label: 'Exploring'),
  ];

  @override
  Widget build(BuildContext context) {
    return _PageWrapper(
      title: 'How do you\nwork best?',
      subtitle: 'Culture fit matters as much as skills',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Work style', style: AppTextStyles.bodyMd),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: List.generate(3, (i) {
              final isSelected = workStyle == _styles[i];
              return Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(right: i < 2 ? AppSpacing.sm : 0),
                  child: GestureDetector(
                    onTap: () => onWorkStyle(_styles[i]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm + 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          _styleLabels[i],
                          style: AppTextStyles.bodyMd.copyWith(
                            color: isSelected
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Text('What does good culture look like to you?',
                  style: AppTextStyles.bodyMd),
              const SizedBox(width: AppSpacing.xs),
              Text('(up to 5)', style: AppTextStyles.label),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: AppConstants.cultureTags.map((tag) {
              final isSelected = cultureTags.contains(tag);
              return GestureDetector(
                onTap: () => onCultureTag(tag),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm + 2,
                      vertical: AppSpacing.xs + 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accent.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isSelected ? AppColors.accent : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    tag,
                    style: AppTextStyles.label.copyWith(
                      color: isSelected
                          ? AppColors.accent
                          : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('When do you want to move?', style: AppTextStyles.bodyMd),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: _timelines.map((t) {
              final isSelected = jobSearchTimeline == t.value;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: _timelines.last.value != t.value ? 6 : 0),
                  child: GestureDetector(
                    onTap: () => onTimeline(t.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          t.label,
                          style: AppTextStyles.label.copyWith(
                            color: isSelected
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// Page 7 — AI Readiness
// ──────────────────────────────────────────────────────────
class _Page7AiReadiness extends StatelessWidget {
  const _Page7AiReadiness({
    required this.answers,
    required this.onAnswer,
  });

  final Map<String, int> answers;
  final void Function(String questionId, int score) onAnswer;

  @override
  Widget build(BuildContext context) {
    return _PageWrapper(
      title: AppConstants.onboardingAiReadinessTitle,
      subtitle: AppConstants.onboardingAiReadinessSubtitle,
      child: Column(
        children: AppConstants.aiReadinessQuestions
            .asMap()
            .entries
            .map((entry) {
          final q = entry.value;
          final selected = answers[q.id];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.key + 1}. ${q.question}',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...q.options.asMap().entries.map((optEntry) {
                  final opt = optEntry.value;
                  final isSelected = selected == opt.score;
                  return GestureDetector(
                    onTap: () => onAnswer(q.id, opt.score),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm + 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              opt.label,
                              style: AppTextStyles.bodyMd.copyWith(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle_rounded,
                                color: AppColors.primary, size: 18),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ).animate(delay: (entry.key * 80).ms).fadeIn(duration: 300.ms),
          );
        }).toList(),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// Shared page wrapper
// ──────────────────────────────────────────────────────────
class _PageWrapper extends StatelessWidget {
  const _PageWrapper({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: AppTextStyles.headlineLg)
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: -0.05, end: 0),
          const SizedBox(height: AppSpacing.xs),
          Text(subtitle, style: AppTextStyles.bodyMd)
              .animate(delay: 80.ms)
              .fadeIn(duration: 300.ms),
          const SizedBox(height: AppSpacing.xl),
          child.animate(delay: 160.ms).fadeIn(duration: 350.ms),
        ],
      ),
    );
  }
}
