import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../router/app_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/constants/app_constants.dart';

class OnboardingWelcomeScreen extends HookConsumerWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final page = useState(0);
    const totalPages = 4;

    void goNext() {
      if (page.value < totalPages - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        );
      } else {
        context.go(AppRoutes.onboardingRole);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(totalPages, (i) {
                      final active = i == page.value;
                      final done = i < page.value;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        width: active ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.primary
                              : done
                                  ? AppColors.primary.withValues(alpha: 0.4)
                                  : AppColors.surface,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.onboardingRole),
                    child: Text(
                      AppConstants.welcomeSkip,
                      style: AppTextStyles.bodyMd
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (i) => page.value = i,
                children: const [
                  _WelcomePage(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF4A47E0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: Icons.rocket_launch_rounded,
                    title: 'Become who\nyou\'re working\ntoward.',
                    body:
                        'This isn\'t a job board. It\'s a community for people who want their work to mean something.',
                  ),
                  _WelcomePage(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00C9A7), Color(0xFF0095AB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: Icons.groups_rounded,
                    title: 'Build\nconnections\nthat last.',
                    body:
                        'Connect with peers, mentors, and companies that share your values — not just your skill set.',
                  ),
                  _WelcomePage(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: Icons.balance_rounded,
                    title: 'Work\nhonestly.',
                    body:
                        'Real salary data. Honest company culture. A community that says what LinkedIn won\'t.',
                  ),
                  _WelcomePage(
                    gradient: LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: Icons.auto_graph_rounded,
                    title: 'Grow\nevery\nday.',
                    body:
                        'Your AI Readiness score, a personalized growth path, and an AI coach — whatever your field.',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: goNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      page.value < totalPages - 1
                          ? AppConstants.welcomeNext
                          : AppConstants.welcomeGetStarted,
                      key: ValueKey(page.value),
                      style: AppTextStyles.buttonText,
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
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({
    required this.gradient,
    required this.icon,
    required this.title,
    required this.body,
  });

  final LinearGradient gradient;
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 40),
                  )
                      .animate()
                      .scale(
                          begin: const Offset(0.7, 0.7),
                          duration: 500.ms,
                          curve: Curves.elasticOut)
                      .fadeIn(duration: 300.ms),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.display.copyWith(height: 1.1),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.md),
                Text(
                  body,
                  style: AppTextStyles.bodyLg
                      .copyWith(color: AppColors.textSecondary, height: 1.5),
                )
                    .animate(delay: 100.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.05, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
