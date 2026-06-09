import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../router/app_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/utils/haptics.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../profile/domain/profile_providers.dart';

class RoleSelectorScreen extends HookConsumerWidget {
  const RoleSelectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final selectedRole = useState<String?>(null);
    final errorMsg = useState<String?>(null);

    Future<void> selectRole(String role) async {
      AppHaptics.buttonTap();
      selectedRole.value = role;
      isLoading.value = true;
      errorMsg.value = null;

      try {
        final user = Supabase.instance.client.auth.currentUser!;
        final repo = ref.read(profileRepositoryProvider);
        await repo.createProfile(
          userId: user.id,
          role: role,
          name: user.email?.split('@').first ?? 'New User',
        );
        ref.invalidate(currentProfileProvider);

        if (context.mounted) {
          context.go(role == 'candidate'
              ? AppRoutes.onboardingCandidate
              : AppRoutes.onboardingEmployer);
        }
      } catch (e) {
        selectedRole.value = null;
        errorMsg.value = 'Something went wrong. Please try again.';
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Text('I am..', style: AppTextStyles.display)
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.1, end: 0),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Choose your path to get started',
                style: AppTextStyles.bodyMd,
              ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
              if (errorMsg.value != null) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: AppColors.danger, size: 16),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          errorMsg.value!,
                          style: AppTextStyles.bodyMd
                              .copyWith(color: AppColors.danger),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 200.ms).shake(
                    hz: 3, offset: const Offset(4, 0)),
              ],
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _RoleCard(
                      icon: Icons.search_rounded,
                      title: 'Looking for a job',
                      subtitle: 'Swipe through curated opportunities\nthat match your skills',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF8B83FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      isLoading: isLoading.value && selectedRole.value == 'candidate',
                      onTap: () => selectRole('candidate'),
                    )
                        .animate(delay: 200.ms)
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppSpacing.md),
                    _RoleCard(
                      icon: Icons.business_center_rounded,
                      title: 'Hiring talent',
                      subtitle: 'Find and match with exceptional\ncandidates for your team',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00E5A0), Color(0xFF00B87A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      isLoading: isLoading.value && selectedRole.value == 'employer',
                      onTap: () => selectRole('employer'),
                    )
                        .animate(delay: 350.ms)
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                  ],
                ),
              ),
              Center(
                child: Text(
                  'You can switch roles later in settings',
                  style: AppTextStyles.label,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
    required this.isLoading,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: isLoading
                  ? const Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headlineSm.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withValues(alpha: 0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
