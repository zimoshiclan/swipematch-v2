import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/profile_model.dart';
import '../domain/profile_providers.dart';
import 'widgets/completion_bar.dart';
import '../../pitch/presentation/pitch_entry_sheet.dart';
import '../../pitch/presentation/pitch_preview_screen.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/utils/currency_utils.dart';
import '../../../shared/widgets/ai_readiness_badge.dart';
import '../../../shared/widgets/skill_tag.dart';
import 'profile_edit_sheet.dart';
import '../../notifications/presentation/notifications_screen.dart';
import '../../notifications/domain/app_notifications_providers.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final unreadCount =
        ref.watch(unreadNotificationCountProvider).valueOrNull ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: context.canPop()
            ? IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    color: AppColors.textPrimary, size: 20),
              )
            : null,
        title: Text('Your Card', style: AppTextStyles.headlineSm),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const NotificationsScreen()),
            ),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined,
                    color: AppColors.textSecondary, size: 22),
                if (unreadCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (profileAsync.valueOrNull != null)
            IconButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) =>
                    ProfileEditSheet(profile: profileAsync.valueOrNull!),
              ),
              icon: const Icon(Icons.edit_outlined,
                  color: AppColors.textSecondary, size: 22),
            ),
          IconButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              ref.invalidate(currentProfileProvider);
            },
            icon: const Icon(Icons.logout_rounded,
                color: AppColors.textSecondary, size: 22),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Text('Failed to load profile', style: AppTextStyles.bodyMd),
        ),
        data: (profile) => profile == null
            ? const Center(child: Text('No profile found'))
            : _ProfileContent(profile: profile),
      ),
    );
  }
}

class _ProfileContent extends HookConsumerWidget {
  const _ProfileContent({required this.profile});
  final ProfileModel profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileHeader(profile: profile),
          const SizedBox(height: AppSpacing.lg),
          CompletionBar(percent: profile.profileCompletion / 100.0),
          const SizedBox(height: AppSpacing.lg),
          _StatsRow(profile: profile),
          const SizedBox(height: AppSpacing.xl),
          _BecomingSection(profile: profile),
          const SizedBox(height: AppSpacing.xl),
          _SkillsSection(skills: profile.skills),
          const SizedBox(height: AppSpacing.xl),
          _PreferencesSection(profile: profile, ref: ref),
          const SizedBox(height: AppSpacing.xl),
          _DangerZone(),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});
  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final initials = profile.name.isNotEmpty
        ? profile.name.split(' ').take(2).map((w) => w[0]).join().toUpperCase()
        : '?';

    return Row(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initials,
              style: AppTextStyles.display.copyWith(color: Colors.white),
            ),
          ),
        ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profile.name, style: AppTextStyles.headlineLg),
              const SizedBox(height: 4),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  _RoleBadge(role: profile.role),
                  if (profile.skills.isNotEmpty)
                    AiReadinessBadge(skills: profile.skills, large: true),
                  if (profile.streakCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '🔥 ${profile.streakCount} day streak',
                        style: AppTextStyles.label,
                      ),
                    ),
                ],
              ),
              if (profile.bio != null) ...[
                const SizedBox(height: 6),
                Text(
                  profile.bio!,
                  style:
                      AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    ).animate(delay: 100.ms).fadeIn(duration: 300.ms);
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});
  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '✦ Building',
        style: AppTextStyles.label.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.profile});
  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final stats = <(String, String)>[
      if (profile.experienceYears != null)
        ('${profile.experienceYears}', 'years exp'),
      if (profile.workStyle != null) (_workLabel(profile.workStyle!), 'work style'),
      if (profile.salaryMin != null && profile.salaryMax != null)
        (
          CurrencyUtils.formatRange(profile.salaryMin!, profile.salaryMax!),
          'salary',
        ),
    ];

    if (stats.isEmpty) return const SizedBox.shrink();

    return Row(
      children: stats
          .map((s) => Expanded(child: _StatChip(value: s.$1, label: s.$2)))
          .toList(),
    ).animate(delay: 200.ms).fadeIn(duration: 300.ms);
  }

  String _workLabel(String s) => switch (s) {
        'remote' => '🌎 Remote',
        'hybrid' => '🏢 Hybrid',
        'on_site' => '🏙️ On-site',
        _ => s,
      };
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.bodyMd.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          Text(label, style: AppTextStyles.label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _BecomingSection extends StatelessWidget {
  const _BecomingSection({required this.profile});
  final ProfileModel profile;

  bool get _hasContent =>
      (profile.workingToward?.isNotEmpty ?? false) ||
      (profile.currentlyLearning?.isNotEmpty ?? false) ||
      profile.workValues.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!_hasContent) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Becoming', style: AppTextStyles.headlineSm),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (profile.workingToward != null &&
                  profile.workingToward!.isNotEmpty) ...[
                _BecomingRow(
                  icon: Icons.rocket_launch_rounded,
                  label: 'Working toward',
                  value: profile.workingToward!,
                ),
              ],
              if (profile.currentlyLearning != null &&
                  profile.currentlyLearning!.isNotEmpty) ...[
                if (profile.workingToward?.isNotEmpty ?? false)
                  const SizedBox(height: AppSpacing.sm),
                _BecomingRow(
                  icon: Icons.menu_book_rounded,
                  label: 'Learning now',
                  value: profile.currentlyLearning!,
                ),
              ],
              if (profile.workValues.isNotEmpty) ...[
                if ((profile.workingToward?.isNotEmpty ?? false) ||
                    (profile.currentlyLearning?.isNotEmpty ?? false))
                  const SizedBox(height: AppSpacing.sm),
                Text('Values', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: profile.workValues
                      .map((v) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(v,
                                style: AppTextStyles.label.copyWith(
                                    color: AppColors.primary)),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    ).animate(delay: 250.ms).fadeIn(duration: 300.ms);
  }
}

class _BecomingRow extends StatelessWidget {
  const _BecomingRow(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTextStyles.label
                      .copyWith(color: AppColors.textSecondary)),
              Text(value,
                  style: AppTextStyles.bodyMd
                      .copyWith(color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkillsSection extends StatelessWidget {
  const _SkillsSection({required this.skills});
  final List<String> skills;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Skills', style: AppTextStyles.headlineSm),
        const SizedBox(height: AppSpacing.sm),
        if (skills.isEmpty)
          Text('No skills added yet.',
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary))
        else
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: skills.map((s) => SkillTag(label: s, highlighted: true)).toList(),
          ),
      ],
    ).animate(delay: 300.ms).fadeIn(duration: 300.ms);
  }
}

class _PreferencesSection extends StatelessWidget {
  const _PreferencesSection({required this.profile, required this.ref});
  final ProfileModel profile;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Preferences', style: AppTextStyles.headlineSm),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _PreferenceRow(
                icon: Icons.visibility_off_outlined,
                title: 'Passive Mode',
                subtitle: 'Stay in the pool without actively swiping',
                trailing: Switch(
                  value: profile.passiveMode,
                  onChanged: (val) => _togglePassive(val),
                  activeThumbColor: AppColors.primary,
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                ),
              ),
              const Divider(color: AppColors.card, height: 1, indent: 52),
              _PreferenceRow(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'New connections and community activity',
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textSecondary),
                onTap: () => context.push('/notifications'),
              ),
              const Divider(color: AppColors.card, height: 1, indent: 52),
              _PreferenceRow(
                icon: Icons.bar_chart_rounded,
                title: 'Salary Truth',
                subtitle: 'Real pay data — contributed anonymously',
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textSecondary),
                onTap: () => context.push('/salary'),
              ),
              const Divider(color: AppColors.card, height: 1, indent: 52),
              _PreferenceRow(
                icon: profile.videoPitchUrl != null
                    ? Icons.videocam_rounded
                    : Icons.videocam_outlined,
                title: profile.videoPitchUrl != null
                    ? '60-second pitch'
                    : 'Add a 60-second pitch',
                subtitle: profile.videoPitchUrl != null
                    ? 'Tap to play or re-record'
                    : 'Skip the CV — let employers hear you',
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textSecondary),
                onTap: () => _openPitch(context, profile),
              ),
            ],
          ),
        ),
      ],
    ).animate(delay: 400.ms).fadeIn(duration: 300.ms);
  }

  void _openPitch(BuildContext context, ProfileModel profile) {
    if (profile.videoPitchUrl != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PitchPreviewScreen(
            profileId: profile.id,
            remoteUrl: profile.videoPitchUrl,
            readOnly: true,
          ),
        ),
      );
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => PitchEntrySheet(profileId: profile.id),
    );
  }

  void _togglePassive(bool val) {
    final repo = ref.read(profileRepositoryProvider);
    repo.togglePassiveMode(profile.id, val);
    ref.invalidate(currentProfileProvider);
  }

}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 18),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary),
      ),
      subtitle: Text(subtitle, style: AppTextStyles.label),
      trailing: trailing,
    );
  }
}

class _DangerZone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Account', style: AppTextStyles.headlineSm),
        const SizedBox(height: AppSpacing.md),
        GestureDetector(
          onTap: () async {
            await Supabase.instance.client.auth.signOut();
            if (context.mounted) context.go('/auth');
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.logout_rounded,
                    color: AppColors.danger, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Sign out',
                  style:
                      AppTextStyles.bodyMd.copyWith(color: AppColors.danger),
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate(delay: 500.ms).fadeIn(duration: 300.ms);
  }
}
