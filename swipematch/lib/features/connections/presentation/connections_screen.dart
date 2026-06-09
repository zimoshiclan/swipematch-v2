import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../profile/domain/profile_model.dart';
import '../../profile/domain/profile_providers.dart';
import '../../network/data/network_repository.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/ai_readiness_badge.dart';
import '../../../shared/widgets/primary_button.dart';

final _netRepoProvider = Provider<NetworkRepository>(
  (_) => NetworkRepository(Supabase.instance.client),
);

class ConnectionsScreen extends HookConsumerWidget {
  const ConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final profile = profileAsync.valueOrNull;

    final connections = useState<List<ProfileModel>>([]);
    final isLoading = useState(true);

    useEffect(() {
      if (profile == null) {
        isLoading.value = false;
        return null;
      }
      ref
          .read(_netRepoProvider)
          .getConnections(profile.id)
          .then((data) {
        connections.value = data;
        isLoading.value = false;
      }).catchError((_) => isLoading.value = false);
      return null;
    }, [profile?.id]);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Connections', style: AppTextStyles.headlineLg),
                  const SizedBox(height: 4),
                  Text(
                    'People you\'ve chosen to build with',
                    style: AppTextStyles.bodyMd
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Divider(color: AppColors.card, height: 1),
                ],
              ),
            ),

            // Content
            Expanded(
              child: isLoading.value
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary))
                  : _AllConnections(
                      connections: connections.value,
                      onRefresh: () {
                        if (profile == null) return;
                        isLoading.value = true;
                        ref
                            .read(_netRepoProvider)
                            .getConnections(profile.id)
                            .then((data) {
                          connections.value = data;
                          isLoading.value = false;
                        });
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// All connections list
// ─────────────────────────────────────────────────────────

class _AllConnections extends StatelessWidget {
  const _AllConnections({required this.connections, required this.onRefresh});
  final List<ProfileModel> connections;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    if (connections.isEmpty) {
      return _EmptyState(
        icon: Icons.handshake_outlined,
        title: 'No connections yet',
        body:
            'Go to The Room and swipe right on someone interesting. When they swipe back — you\'re connected.',
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: connections.length,
        itemBuilder: (ctx, i) => _ConnectionCard(person: connections[i])
            .animate(delay: (i * 50).ms)
            .fadeIn(duration: 300.ms)
            .slideY(begin: 0.04, end: 0),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Connection card
// ─────────────────────────────────────────────────────────

class _ConnectionCard extends ConsumerWidget {
  const _ConnectionCard({required this.person});
  final ProfileModel person;

  Future<void> _openChat(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final matchId =
          await ref.read(_netRepoProvider).getOrCreateMatchId(person.id);
      if (!context.mounted) return;
      context.push(AppRoutes.chatPath(matchId));
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text("Couldn't open the chat. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initials = person.name.isNotEmpty
        ? person.name.split(' ').take(2).map((w) => w[0]).join().toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.card, width: 1),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
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
                style: AppTextStyles.bodyMd.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        person.name,
                        style: AppTextStyles.bodyMd
                            .copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (person.skills.isNotEmpty) ...[
                      const SizedBox(width: AppSpacing.xs),
                      AiReadinessBadge(skills: person.skills),
                    ],
                  ],
                ),
                if (person.workingToward != null &&
                    person.workingToward!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    person.workingToward!,
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ] else if (person.headline != null &&
                    person.headline!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    person.headline!,
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (person.workValues.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: 4,
                    children: person.workValues
                        .take(2)
                        .map((v) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                v,
                                style: AppTextStyles.label.copyWith(
                                    color: AppColors.accent, fontSize: 10),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Message button
          GestureDetector(
            onTap: () => _openChat(context, ref),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.chat_bubble_outline_rounded,
                  color: AppColors.primary, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 32),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title,
                style: AppTextStyles.headlineSm,
                textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(body,
                style: AppTextStyles.bodyMd
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
