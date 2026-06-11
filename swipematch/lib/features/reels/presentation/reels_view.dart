import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/reels_providers.dart';
import '../../profile/domain/profile_model.dart';
import '../../room/domain/room_providers.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/video_pitch_player.dart';

/// Vertical, full-screen reels feed of people. Each page shows the person's
/// 60-second intro video, or — when they have none — their recent posts and
/// achievements. Connect / Pass / Super-connect reuse the Room's swipe
/// handlers, so a mutual right-swipe still triggers the connection reveal.
class ReelsView extends HookConsumerWidget {
  const ReelsView({super.key, required this.deck});

  final List<ProfileModel> deck;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageCtrl = usePageController();
    final index = useState(0);

    void next() {
      if (index.value < deck.length - 1) {
        pageCtrl.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        ref.read(roomNotifierProvider.notifier).onDeckEmpty();
      }
    }

    return PageView.builder(
      controller: pageCtrl,
      scrollDirection: Axis.vertical,
      itemCount: deck.length,
      onPageChanged: (i) => index.value = i,
      itemBuilder: (context, i) {
        final person = deck[i];
        return _ReelPage(
          person: person,
          isActive: i == index.value,
          onPass: () {
            ref.read(roomNotifierProvider.notifier).onSwipePast(person);
            next();
          },
          onConnect: () {
            ref.read(roomNotifierProvider.notifier).onSwipeRight(person);
            next();
          },
          onSuperConnect: () {
            ref.read(roomNotifierProvider.notifier).onSuperConnect(person);
            next();
          },
        );
      },
    );
  }
}

class _ReelPage extends StatelessWidget {
  const _ReelPage({
    required this.person,
    required this.isActive,
    required this.onPass,
    required this.onConnect,
    required this.onSuperConnect,
  });

  final ProfileModel person;
  final bool isActive;
  final VoidCallback onPass;
  final VoidCallback onConnect;
  final VoidCallback onSuperConnect;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Media layer: video if present, else posts/achievements fallback.
        if (person.videoPitchUrl != null)
          VideoPitchPlayer(url: person.videoPitchUrl!, isActive: isActive)
        else
          _PostsFallback(person: person),

        // Bottom gradient + info + actions
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.xl, AppSpacing.md, AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.75),
                ],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: _PersonInfo(person: person)),
                _ReelActions(
                  onPass: onPass,
                  onConnect: onConnect,
                  onSuperConnect: onSuperConnect,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PersonInfo extends StatelessWidget {
  const _PersonInfo({required this.person});
  final ProfileModel person;

  @override
  Widget build(BuildContext context) {
    final location = [person.city, person.country]
        .where((s) => s != null && s.trim().isNotEmpty)
        .join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                person.name,
                style: AppTextStyles.headlineSm.copyWith(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (person.persona != null) ...[
              const SizedBox(width: AppSpacing.xs),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(person.persona!,
                    style:
                        AppTextStyles.label.copyWith(color: Colors.white)),
              ),
            ],
          ],
        ),
        if (person.headline != null && person.headline!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            person.headline!,
            style: AppTextStyles.bodyMd
                .copyWith(color: Colors.white.withValues(alpha: 0.85)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (location.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.place_outlined, size: 13, color: Colors.white70),
              const SizedBox(width: 3),
              Text(location,
                  style:
                      AppTextStyles.label.copyWith(color: Colors.white70)),
            ],
          ),
        ],
        if (person.connectionIntents.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: person.connectionIntents
                .take(3)
                .map((i) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        AppConstants.connectionIntents[i] ?? i,
                        style:
                            AppTextStyles.label.copyWith(color: Colors.white),
                      ),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _ReelActions extends StatelessWidget {
  const _ReelActions({
    required this.onPass,
    required this.onConnect,
    required this.onSuperConnect,
  });

  final VoidCallback onPass;
  final VoidCallback onConnect;
  final VoidCallback onSuperConnect;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleAction(
          icon: Icons.auto_awesome_rounded,
          color: AppColors.primary,
          onTap: onSuperConnect,
        ),
        const SizedBox(height: AppSpacing.sm),
        _CircleAction(
          icon: Icons.handshake_rounded,
          color: AppColors.accent,
          size: 60,
          onTap: onConnect,
        ),
        const SizedBox(height: AppSpacing.sm),
        _CircleAction(
          icon: Icons.close_rounded,
          color: AppColors.textSecondary,
          onTap: onPass,
        ),
      ],
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 48,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.4),
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(icon, color: color, size: size * 0.45),
      ),
    );
  }
}

/// Shown for people without an intro video: a gradient backdrop with their
/// goal, plus their recent posts and achievements.
class _PostsFallback extends ConsumerWidget {
  const _PostsFallback({required this.person});
  final ProfileModel person;

  static const _gradients = [
    [Color(0xFF6C63FF), Color(0xFF4A47E0)],
    [Color(0xFF00C9A7), Color(0xFF0095AB)],
    [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
    [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    [Color(0xFF0EA5E9), Color(0xFF0369A1)],
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grad =
        _gradients[person.name.codeUnits.fold(0, (a, b) => a + b) % _gradients.length];
    final postsAsync = ref.watch(authorPostsProvider(person.id));

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: grad,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.workspace_premium_rounded,
                  color: Colors.white, size: 32),
              const SizedBox(height: AppSpacing.sm),
              if (person.workingToward != null &&
                  person.workingToward!.isNotEmpty)
                Text(
                  person.workingToward!,
                  style: AppTextStyles.headlineSm.copyWith(color: Colors.white),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: postsAsync.when(
                  loading: () => const Center(
                    child:
                        CircularProgressIndicator(color: Colors.white),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (posts) => posts.isEmpty
                      ? Text(
                          'No posts yet — connect to start the conversation.',
                          style: AppTextStyles.bodyMd
                              .copyWith(color: Colors.white70),
                        )
                      : ListView.separated(
                          itemCount: posts.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (_, i) => _PostCard(
                            title: posts[i].title,
                            content: posts[i].content,
                            type: posts[i].type,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.title,
    required this.content,
    required this.type,
  });

  final String title;
  final String content;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(type.toUpperCase(),
              style: AppTextStyles.label
                  .copyWith(color: Colors.white.withValues(alpha: 0.7))),
          const SizedBox(height: 2),
          Text(title,
              style: AppTextStyles.bodyLg.copyWith(
                  color: Colors.white, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(content,
              style: AppTextStyles.bodyMd.copyWith(color: Colors.white70),
              maxLines: 3,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
