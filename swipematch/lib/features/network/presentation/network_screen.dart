import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';

import '../data/network_repository.dart';
import '../domain/comment_model.dart';
import '../domain/comments_providers.dart';
import '../domain/post_model.dart';
import '../domain/posts_providers.dart';
import '../../profile/domain/profile_model.dart';
import '../../profile/domain/profile_providers.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/utils/haptics.dart';
import '../../../shared/utils/date_utils.dart' as du;
import '../../../shared/widgets/ai_readiness_badge.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/skill_tag.dart';

final _networkRepoProvider = Provider<NetworkRepository>(
  (ref) => NetworkRepository(Supabase.instance.client),
);

class NetworkScreen extends HookConsumerWidget {
  const NetworkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = useState(0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _Header(tabIndex: tabIndex),
            Expanded(
              child: IndexedStack(
                index: tabIndex.value,
                children: const [
                  _PeopleTab(),
                  _PostsTab(),
                  _SavedTab(),
                  _ConnectionsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: tabIndex.value == 1
          ? _CreatePostFab()
          : null,
    );
  }
}

// ─────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.tabIndex});
  final ValueNotifier<int> tabIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Community', style: AppTextStyles.headlineLg),
          const SizedBox(height: 4),
          Text(
            'Build the career and life you\'re working toward — together',
            style:
                AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _Tab(
                  label: 'People',
                  selected: tabIndex.value == 0,
                  onTap: () => tabIndex.value = 0,
                ),
                const SizedBox(width: AppSpacing.sm),
                _Tab(
                  label: 'Posts',
                  selected: tabIndex.value == 1,
                  onTap: () => tabIndex.value = 1,
                ),
                const SizedBox(width: AppSpacing.sm),
                _Tab(
                  label: 'Saved',
                  selected: tabIndex.value == 2,
                  onTap: () => tabIndex.value = 2,
                ),
                const SizedBox(width: AppSpacing.sm),
                _Tab(
                  label: 'Connections',
                  selected: tabIndex.value == 3,
                  onTap: () => tabIndex.value = 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.card, height: 1),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMd.copyWith(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// People tab (discover professionals)
// ─────────────────────────────────────────────────────────

class _PeopleTab extends HookConsumerWidget {
  const _PeopleTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final profile = profileAsync.valueOrNull;
    final repo = ref.read(_networkRepoProvider);

    final suggestions = useState<List<ProfileModel>>([]);
    final connected = useState<Set<String>>({});
    final isLoading = useState(true);

    useEffect(() {
      if (profile == null) return null;
      repo.getSuggestions(profile.id).then((data) {
        suggestions.value = data;
        isLoading.value = false;
      }).catchError((_) {
        isLoading.value = false;
      });
      return null;
    }, [profile?.id]);

    if (isLoading.value) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (suggestions.value.isEmpty) {
      return _EmptyState(
        icon: Icons.people_outline_rounded,
        title: 'No suggestions yet',
        subtitle: 'Come back later as more professionals join.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: suggestions.value.length,
      itemBuilder: (context, i) {
        final person = suggestions.value[i];
        final isConnected = connected.value.contains(person.id);
        return _PersonCard(
          person: person,
          isConnected: isConnected,
          onConnect: () {
            AppHaptics.swipeRight();
            if (profile == null) return;
            connected.value = {...connected.value, person.id};
            repo.sendRequest(profile.id, person.id).catchError((_) {
              connected.value = connected.value
                  .where((id) => id != person.id)
                  .toSet();
            });
          },
        ).animate(delay: (i * 60).ms).fadeIn(duration: 300.ms).slideY(begin: 0.05);
      },
    );
  }
}

// ─────────────────────────────────────────────────────────
// Posts tab
// ─────────────────────────────────────────────────────────

class _PostsTab extends HookConsumerWidget {
  const _PostsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsNotifierProvider);

    return postsAsync.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary)),
      error: (_, __) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: AppColors.textSecondary, size: 48),
              const SizedBox(height: AppSpacing.md),
              Text('Could not load posts', style: AppTextStyles.headlineSm),
              const SizedBox(height: AppSpacing.sm),
              PrimaryButton(
                label: 'Retry',
                onPressed: () =>
                    ref.read(postsNotifierProvider.notifier).refresh(),
              ),
            ],
          ),
        ),
      ),
      data: (posts) {
        if (posts.isEmpty) {
          return _EmptyState(
            icon: Icons.article_outlined,
            title: AppConstants.postsEmptyTitle,
            subtitle: AppConstants.postsEmptySubtitle,
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          onRefresh: () => ref.read(postsNotifierProvider.notifier).refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: posts.length,
            itemBuilder: (context, i) {
              return _PostCard(post: posts[i])
                  .animate(delay: (i * 50).ms)
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.04);
            },
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────
// Saved tab (bookmarked posts)
// ─────────────────────────────────────────────────────────

class _SavedTab extends HookConsumerWidget {
  const _SavedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedAsync = ref.watch(savedPostsProvider);

    return savedAsync.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary)),
      error: (_, __) => _EmptyState(
        icon: Icons.bookmark_border_rounded,
        title: 'Could not load saved posts',
        subtitle: 'Pull to refresh and try again.',
      ),
      data: (posts) {
        if (posts.isEmpty) {
          return _EmptyState(
            icon: Icons.bookmark_border_rounded,
            title: AppConstants.savedEmptyTitle,
            subtitle: AppConstants.savedEmptySubtitle,
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          onRefresh: () async => ref.invalidate(savedPostsProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: posts.length,
            itemBuilder: (context, i) {
              return _PostCard(post: posts[i])
                  .animate(delay: (i * 50).ms)
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.04);
            },
          ),
        );
      },
    );
  }
}

class _PostCard extends HookConsumerWidget {
  const _PostCard({required this.post});
  final PostModel post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typeLabel =
        AppConstants.postTypeLabels[post.type] ?? post.type;
    final heartKey = useState(0);
    final isTrending =
        post.likesCount >= AppConstants.trendingLikeThreshold;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GestureDetector(
        onDoubleTap: () {
          AppHaptics.swipeRight();
          heartKey.value++;
          if (!post.isLikedByMe) {
            ref.read(postsNotifierProvider.notifier).toggleLike(post.id);
          }
        },
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isTrending
                      ? AppColors.accent.withValues(alpha: 0.4)
                      : AppColors.card,
                  width: 1,
                ),
              ),
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _AuthorAvatar(
                name: post.authorName,
                avatarUrl: post.authorAvatarUrl,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            post.authorName,
                            style: AppTextStyles.bodyMd
                                .copyWith(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (post.authorAiReadinessScore != null) ...[
                          const SizedBox(width: AppSpacing.xs),
                          _AiScoreChip(score: post.authorAiReadinessScore!),
                        ],
                      ],
                    ),
                    Text(
                      du.AppDateUtils.timeAgo(post.createdAt),
                      style: AppTextStyles.label
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              _TypeChip(label: typeLabel),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            post.title,
            style: AppTextStyles.bodyLg
                .copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            post.content,
            style: AppTextStyles.bodyMd
                .copyWith(color: AppColors.textSecondary),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (post.mediaUrl != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _PostMedia(url: post.mediaUrl!, isVideo: post.mediaType == 'video'),
          ],
          if (post.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: post.tags
                  .take(5)
                  .map((t) => SkillTag(label: t, highlighted: false))
                  .toList(),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.card, height: 1),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              _LikeButton(post: post),
              const SizedBox(width: AppSpacing.md),
              _CommentButton(post: post),
              const Spacer(),
              if (isTrending) ...[
                const _TrendingChip(),
                const SizedBox(width: AppSpacing.sm),
              ],
              _BookmarkButton(post: post),
            ],
          ),
                ],
              ),
            ),
            if (heartKey.value > 0)
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: _HeartBurst(key: ValueKey(heartKey.value)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeartBurst extends StatelessWidget {
  const _HeartBurst({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.favorite_rounded,
      color: Colors.white,
      size: 96,
      shadows: [
        Shadow(color: Colors.black54, blurRadius: 16),
      ],
    )
        .animate()
        .scale(
          begin: const Offset(0.4, 0.4),
          end: const Offset(1.1, 1.1),
          duration: 220.ms,
          curve: Curves.easeOutBack,
        )
        .fadeIn(duration: 120.ms)
        .then(delay: 250.ms)
        .fadeOut(duration: 280.ms);
  }
}

class _TrendingChip extends StatelessWidget {
  const _TrendingChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 10)),
          const SizedBox(width: 4),
          Text(
            AppConstants.trendingLabel,
            style: AppTextStyles.label.copyWith(
                color: AppColors.accent, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _CommentButton extends StatelessWidget {
  const _CommentButton({required this.post});
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppHaptics.buttonTap();
        _showCommentsSheet(context, post.id);
      },
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_outline_rounded,
              color: AppColors.textSecondary, size: 16),
          const SizedBox(width: 4),
          Text(
            '${post.commentsCount}',
            style: AppTextStyles.label
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _BookmarkButton extends ConsumerWidget {
  const _BookmarkButton({required this.post});
  final PostModel post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        AppHaptics.buttonTap();
        ref.read(postsNotifierProvider.notifier).toggleBookmark(post.id);
      },
      child: Icon(
        post.isBookmarkedByMe
            ? Icons.bookmark_rounded
            : Icons.bookmark_border_rounded,
        color: post.isBookmarkedByMe
            ? AppColors.primary
            : AppColors.textSecondary,
        size: 18,
      ),
    );
  }
}

void _showCommentsSheet(BuildContext context, String postId) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => ProviderScope(
      parent: ProviderScope.containerOf(context),
      child: _CommentsSheet(postId: postId),
    ),
  );
}

typedef _CommentEntry = ({CommentModel comment, bool isReply});

class _CommentsSheet extends HookConsumerWidget {
  const _CommentsSheet({required this.postId});
  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = useTextEditingController();
    final focusNode = useFocusNode();
    final sending = useState(false);
    final hasText = useState(false);
    final replyingTo = useState<CommentModel?>(null);
    useEffect(() {
      void listener() => hasText.value = ctrl.text.trim().isNotEmpty;
      ctrl.addListener(listener);
      return () => ctrl.removeListener(listener);
    }, [ctrl]);

    final commentsAsync = ref.watch(commentsProvider(postId));

    void startReply(CommentModel c) {
      AppHaptics.buttonTap();
      replyingTo.value = c;
      focusNode.requestFocus();
    }

    Future<void> submit() async {
      final text = ctrl.text.trim();
      if (text.isEmpty || sending.value) return;
      AppHaptics.buttonTap();
      sending.value = true;
      try {
        await ref
            .read(commentsProvider(postId).notifier)
            .add(text, parentId: replyingTo.value?.id);
        ctrl.clear();
        replyingTo.value = null;
      } finally {
        sending.value = false;
      }
    }

    final mq = MediaQuery.of(context);
    // Keep the sheet + keyboard within the screen to avoid overflow.
    final sheetHeight =
        (mq.size.height * 0.85 - mq.viewInsets.bottom).clamp(220.0, mq.size.height);

    return Padding(
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: SizedBox(
        height: sheetHeight,
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Text(AppConstants.commentsTitle,
                      style: AppTextStyles.headlineSm),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded,
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.card, height: 1),
            Expanded(
              child: commentsAsync.when(
                loading: () => const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primary)),
                error: (_, __) => Center(
                  child: Text('Could not load comments',
                      style: AppTextStyles.bodyMd
                          .copyWith(color: AppColors.textSecondary)),
                ),
                data: (comments) {
                  if (comments.isEmpty) {
                    return _EmptyState(
                      icon: Icons.mode_comment_outlined,
                      title: AppConstants.commentsEmptyTitle,
                      subtitle: AppConstants.commentsEmptySubtitle,
                    );
                  }
                  // Group one level of replies under their parent comment.
                  final repliesByParent = <String, List<CommentModel>>{};
                  for (final c in comments) {
                    if (c.parentId != null) {
                      repliesByParent.putIfAbsent(c.parentId!, () => []).add(c);
                    }
                  }
                  final entries = <_CommentEntry>[];
                  for (final c in comments.where((c) => c.parentId == null)) {
                    entries.add((comment: c, isReply: false));
                    for (final r in repliesByParent[c.id] ?? const []) {
                      entries.add((comment: r, isReply: true));
                    }
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    itemCount: entries.length,
                    itemBuilder: (context, i) {
                      final e = entries[i];
                      return _CommentTile(
                        comment: e.comment,
                        isReply: e.isReply,
                        onLike: () => ref
                            .read(commentsProvider(postId).notifier)
                            .toggleLike(e.comment.id),
                        onReply:
                            e.isReply ? null : () => startReply(e.comment),
                      ).animate().fadeIn(duration: 200.ms);
                    },
                  );
                },
              ),
            ),
            const Divider(color: AppColors.card, height: 1),
            if (replyingTo.value != null)
              Container(
                color: AppColors.primary.withValues(alpha: 0.08),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                child: Row(
                  children: [
                    const Icon(Icons.reply_rounded,
                        color: AppColors.primary, size: 16),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        'Replying to ${replyingTo.value!.authorName}',
                        style: AppTextStyles.label
                            .copyWith(color: AppColors.primary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => replyingTo.value = null,
                      child: const Icon(Icons.close_rounded,
                          color: AppColors.textSecondary, size: 16),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm,
                  AppSpacing.md, AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ctrl,
                      focusNode: focusNode,
                      style: AppTextStyles.bodyMd,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => submit(),
                      decoration: InputDecoration(
                        hintText: AppConstants.commentHint,
                        filled: true,
                        fillColor: AppColors.card,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: hasText.value && !sending.value ? submit : null,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: hasText.value
                            ? AppColors.primary
                            : AppColors.card,
                        shape: BoxShape.circle,
                      ),
                      child: sending.value
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Icon(
                              Icons.send_rounded,
                              color: hasText.value
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              size: 20,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.comment,
    this.isReply = false,
    this.onLike,
    this.onReply,
  });

  final CommentModel comment;
  final bool isReply;
  final VoidCallback? onLike;
  final VoidCallback? onReply;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isReply ? AppSpacing.xl : 0,
        top: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isReply)
            const Padding(
              padding: EdgeInsets.only(top: 6, right: 4),
              child: Icon(Icons.subdirectory_arrow_right_rounded,
                  color: AppColors.textSecondary, size: 16),
            ),
          _AuthorAvatar(
            name: comment.authorName,
            avatarUrl: comment.authorAvatarUrl,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        comment.authorName,
                        style: AppTextStyles.bodyMd
                            .copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (comment.authorAiReadinessScore != null) ...[
                      const SizedBox(width: AppSpacing.xs),
                      _AiScoreChip(score: comment.authorAiReadinessScore!),
                    ],
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      du.AppDateUtils.timeAgo(comment.createdAt),
                      style: AppTextStyles.label
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  comment.content,
                  style: AppTextStyles.bodyMd
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppHaptics.buttonTap();
                        onLike?.call();
                      },
                      child: Row(
                        children: [
                          Icon(
                            comment.isLikedByMe
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: comment.isLikedByMe
                                ? AppColors.danger
                                : AppColors.textSecondary,
                            size: 14,
                          ),
                          if (comment.likesCount > 0) ...[
                            const SizedBox(width: 4),
                            Text(
                              '${comment.likesCount}',
                              style: AppTextStyles.label.copyWith(
                                color: comment.isLikedByMe
                                    ? AppColors.danger
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (onReply != null) ...[
                      const SizedBox(width: AppSpacing.md),
                      GestureDetector(
                        onTap: onReply,
                        child: Text(
                          'Reply',
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LikeButton extends ConsumerWidget {
  const _LikeButton({required this.post});
  final PostModel post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        AppHaptics.buttonTap();
        ref.read(postsNotifierProvider.notifier).toggleLike(post.id);
      },
      child: Row(
        children: [
          Icon(
            post.isLikedByMe
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: post.isLikedByMe ? AppColors.danger : AppColors.textSecondary,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '${post.likesCount}',
            style: AppTextStyles.label.copyWith(
              color: post.isLikedByMe
                  ? AppColors.danger
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthorAvatar extends StatelessWidget {
  const _AuthorAvatar({required this.name, this.avatarUrl});
  final String name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty
        ? name.split(' ').take(2).map((w) => w[0]).join().toUpperCase()
        : '?';

    if (avatarUrl != null) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(avatarUrl!),
      );
    }

    return Container(
      width: 40,
      height: 40,
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
          style: AppTextStyles.label.copyWith(
              color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.label});
  final String label;

  static const _colors = <String, Color>{
    'Real Talk': Color(0xFFEF4444),
    'Small Win': Color(0xFF10B981),
    'Need Advice': Color(0xFFF59E0B),
    'Research': Color(0xFF6C63FF),
    'Essay': Color(0xFF00C9A7),
    'Achievement': Color(0xFFFF8E53),
    'Collab Call': Color(0xFF8B5CF6),
    'Insight': Color(0xFF0095AB),
  };

  @override
  Widget build(BuildContext context) {
    final color = _colors[label] ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
            color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _AiScoreChip extends StatelessWidget {
  const _AiScoreChip({required this.score});
  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '${AppConstants.aiReadinessLabel(score)} $score',
        style: AppTextStyles.label
            .copyWith(color: AppColors.accent, fontSize: 9),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Post media (image + inline video)
// ─────────────────────────────────────────────────────────

class _PostMedia extends StatelessWidget {
  const _PostMedia({required this.url, required this.isVideo});
  final String url;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: isVideo
          ? _PostVideoPlayer(url: url)
          : ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: CachedNetworkImage(
                imageUrl: url,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 200,
                  color: AppColors.card,
                  child: const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary, strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 160,
                  color: AppColors.card,
                  child: const Icon(Icons.broken_image_outlined,
                      color: AppColors.textSecondary),
                ),
              ),
            ),
    );
  }
}

class _PostVideoPlayer extends HookWidget {
  const _PostVideoPlayer({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    final controller = useState<VideoPlayerController?>(null);
    final muted = useState(true);

    useEffect(() {
      final c = VideoPlayerController.networkUrl(Uri.parse(url));
      c.initialize().then((_) {
        c.setLooping(true);
        c.setVolume(0);
        controller.value = c;
      }).catchError((_) {});
      return () => c.dispose();
    }, [url]);

    final ctrl = controller.value;

    if (ctrl == null || !ctrl.value.isInitialized) {
      return Container(
        height: 220,
        color: AppColors.card,
        child: const Center(
          child: CircularProgressIndicator(
              color: AppColors.primary, strokeWidth: 2),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        AppHaptics.buttonTap();
        ctrl.value.isPlaying ? ctrl.pause() : ctrl.play();
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 360),
        child: AspectRatio(
          aspectRatio: ctrl.value.aspectRatio == 0 ? 16 / 9 : ctrl.value.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(ctrl),
              ValueListenableBuilder<VideoPlayerValue>(
                valueListenable: ctrl,
                builder: (context, value, _) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      if (!value.isPlaying)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(Icons.play_arrow_rounded,
                              color: Colors.white, size: 36),
                        ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            final newMuted = !muted.value;
                            muted.value = newMuted;
                            ctrl.setVolume(newMuted ? 0 : 1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Create Post FAB + bottom sheet
// ─────────────────────────────────────────────────────────

class _CreatePostFab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      onPressed: () => _showCreateSheet(context, ref),
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.edit_rounded, color: Colors.white),
      label: Text('Post', style: AppTextStyles.buttonText),
    );
  }

  void _showCreateSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: const _CreatePostSheet(),
      ),
    );
  }
}

class _CreatePostSheet extends HookConsumerWidget {
  const _CreatePostSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleCtrl = useTextEditingController();
    final contentCtrl = useTextEditingController();
    final tagsCtrl = useTextEditingController();
    final selectedType = useState(AppConstants.postTypes.first);
    final isLoading = useState(false);
    final mediaFile = useState<File?>(null);
    final mediaIsVideo = useState(false);
    final error = useState<String?>(null);
    final picker = useMemoized(ImagePicker.new);

    Future<void> pickMedia({required bool video}) async {
      AppHaptics.buttonTap();
      try {
        final picked = video
            ? await picker.pickVideo(
                source: ImageSource.gallery,
                maxDuration: const Duration(minutes: 3),
              )
            : await picker.pickImage(
                source: ImageSource.gallery,
                maxWidth: 1920,
                imageQuality: 85,
              );
        if (picked != null) {
          mediaFile.value = File(picked.path);
          mediaIsVideo.value = video;
          error.value = null;
        }
      } catch (_) {
        error.value = 'Could not open media. Check app permissions.';
      }
    }

    Future<void> submit() async {
      final title = titleCtrl.text.trim();
      final content = contentCtrl.text.trim();
      if (title.isEmpty || content.isEmpty) return;

      AppHaptics.buttonTap();
      isLoading.value = true;
      error.value = null;
      try {
        final tags = tagsCtrl.text
            .split(',')
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty)
            .toList();

        await ref.read(postsNotifierProvider.notifier).createPost(
              type: selectedType.value,
              title: title,
              content: content,
              tags: tags,
              mediaFile: mediaFile.value,
              isVideo: mediaIsVideo.value,
            );

        if (context.mounted) Navigator.of(context).pop();
      } catch (_) {
        error.value = 'Could not share your post. Please try again.';
      } finally {
        isLoading.value = false;
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(AppConstants.createPostTitle,
                      style: AppTextStyles.headlineSm),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded,
                      color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Type', style: AppTextStyles.bodyMd),
            const SizedBox(height: AppSpacing.xs),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: AppConstants.postTypes.map((type) {
                  final label = AppConstants.postTypeLabels[type] ?? type;
                  final active = selectedType.value == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: GestureDetector(
                      onTap: () => selectedType.value = type,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm + 2,
                            vertical: AppSpacing.xs + 2),
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : AppColors.card,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          label,
                          style: AppTextStyles.label.copyWith(
                            color: active
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontWeight: active
                                ? FontWeight.w700
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: titleCtrl,
              style: AppTextStyles.bodyLg,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: AppConstants.postTitleHint,
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: contentCtrl,
              style: AppTextStyles.bodyMd,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: AppConstants.postContentHint,
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: tagsCtrl,
              style: AppTextStyles.bodyMd,
              decoration: InputDecoration(
                hintText: 'Tags (comma separated — e.g. AI, Healthcare, Research)',
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (mediaFile.value != null)
              _MediaPreview(
                file: mediaFile.value!,
                isVideo: mediaIsVideo.value,
                onRemove: () => mediaFile.value = null,
              )
            else
              Row(
                children: [
                  Expanded(
                    child: _MediaPickButton(
                      icon: Icons.image_outlined,
                      label: AppConstants.postAddPhoto,
                      onTap: () => pickMedia(video: false),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _MediaPickButton(
                      icon: Icons.videocam_outlined,
                      label: AppConstants.postAddVideo,
                      onTap: () => pickMedia(video: true),
                    ),
                  ),
                ],
              ),
            if (error.value != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                error.value!,
                style: AppTextStyles.label.copyWith(color: AppColors.danger),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: isLoading.value && mediaFile.value != null
                  ? AppConstants.postMediaUploading
                  : 'Share with Network',
              onPressed: submit,
              isLoading: isLoading.value,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

class _MediaPickButton extends StatelessWidget {
  const _MediaPickButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.bodyMd
                  .copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaPreview extends StatelessWidget {
  const _MediaPreview({
    required this.file,
    required this.isVideo,
    required this.onRemove,
  });
  final File file;
  final bool isVideo;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: isVideo
              ? Container(
                  height: 160,
                  width: double.infinity,
                  color: AppColors.card,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.movie_creation_outlined,
                          color: AppColors.primary, size: 36),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Video ready to share',
                          style: AppTextStyles.label),
                    ],
                  ),
                )
              : ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240),
                  child: Image.file(
                    file,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.close_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Connections tab (unchanged behaviour)
// ─────────────────────────────────────────────────────────

class _ConnectionsTab extends HookConsumerWidget {
  const _ConnectionsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final profile = profileAsync.valueOrNull;
    final repo = ref.read(_networkRepoProvider);

    final connections = useState<List<ProfileModel>>([]);
    final isLoading = useState(true);

    useEffect(() {
      if (profile == null) return null;
      repo.getConnections(profile.id).then((data) {
        connections.value = data;
        isLoading.value = false;
      }).catchError((_) {
        isLoading.value = false;
      });
      return null;
    }, [profile?.id]);

    if (isLoading.value) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (connections.value.isEmpty) {
      return _EmptyState(
        icon: Icons.handshake_outlined,
        title: 'No connections yet',
        subtitle: 'Start connecting with professionals in the People tab.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: connections.value.length,
      itemBuilder: (context, i) {
        return _PersonCard(
          person: connections.value[i],
          isConnected: true,
          onConnect: () {},
        ).animate(delay: (i * 60).ms).fadeIn(duration: 300.ms);
      },
    );
  }
}

// ─────────────────────────────────────────────────────────
// Person card (shared)
// ─────────────────────────────────────────────────────────

class _PersonCard extends StatelessWidget {
  const _PersonCard({
    required this.person,
    required this.isConnected,
    required this.onConnect,
  });

  final ProfileModel person;
  final bool isConnected;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: 48,
            height: 48,
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
                if (person.headline != null && person.headline!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    person.headline!,
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ] else if (person.experienceYears != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${person.experienceYears} yrs experience',
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
                if (person.skills.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: person.skills
                        .take(3)
                        .map((s) => SkillTag(label: s, highlighted: false))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          isConnected
              ? Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Connected',
                    style: AppTextStyles.label.copyWith(
                        color: AppColors.accent, fontWeight: FontWeight.w600),
                  ),
                )
              : GestureDetector(
                  onTap: onConnect,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Connect',
                      style: AppTextStyles.label.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Empty state (shared)
// ─────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 56),
            const SizedBox(height: AppSpacing.md),
            Text(title,
                style: AppTextStyles.headlineSm,
                textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              style: AppTextStyles.bodyMd
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
