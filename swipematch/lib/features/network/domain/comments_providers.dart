import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../profile/domain/profile_providers.dart';
import '../data/comments_repository.dart';
import 'comment_model.dart';
import 'posts_providers.dart';

final commentsRepositoryProvider = Provider<CommentsRepository>(
  (ref) => CommentsRepository(Supabase.instance.client),
);

/// Comments for a single post, keyed by post id.
final commentsProvider = AutoDisposeAsyncNotifierProviderFamily<CommentsNotifier,
    List<CommentModel>, String>(CommentsNotifier.new);

class CommentsNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<CommentModel>, String> {
  @override
  Future<List<CommentModel>> build(String postId) async {
    final profile = ref.read(currentProfileProvider).valueOrNull;
    return ref
        .read(commentsRepositoryProvider)
        .getComments(postId, currentProfileId: profile?.id);
  }

  /// Adds a comment (or a reply when [parentId] is set), optimistically,
  /// and bumps the parent post's count.
  Future<void> add(String content, {String? parentId}) async {
    final profile = ref.read(currentProfileProvider).valueOrNull;
    if (profile == null) return;

    final comment = await ref.read(commentsRepositoryProvider).addComment(
          postId: arg,
          authorId: profile.id,
          content: content,
          parentId: parentId,
        );

    state = AsyncData([...(state.valueOrNull ?? []), comment]);
    ref.read(postsNotifierProvider.notifier).bumpCommentCount(arg, 1);
  }

  /// Optimistically toggles a like on a single comment.
  Future<void> toggleLike(String commentId) async {
    final profile = ref.read(currentProfileProvider).valueOrNull;
    if (profile == null) return;

    final current = state.valueOrNull ?? [];
    final idx = current.indexWhere((c) => c.id == commentId);
    if (idx == -1) return;

    final comment = current[idx];
    final updated = comment.isLikedByMe
        ? comment.copyWith(
            isLikedByMe: false,
            likesCount: (comment.likesCount - 1).clamp(0, 1 << 30),
          )
        : comment.copyWith(
            isLikedByMe: true,
            likesCount: comment.likesCount + 1,
          );

    state = AsyncData(List<CommentModel>.from(current)..[idx] = updated);

    final repo = ref.read(commentsRepositoryProvider);
    try {
      if (comment.isLikedByMe) {
        await repo.unlikeComment(commentId, profile.id);
      } else {
        await repo.likeComment(commentId, profile.id);
      }
    } catch (_) {
      final revert = List<CommentModel>.from(state.valueOrNull ?? []);
      final ri = revert.indexWhere((c) => c.id == commentId);
      if (ri != -1) revert[ri] = comment;
      state = AsyncData(revert);
    }
  }
}
