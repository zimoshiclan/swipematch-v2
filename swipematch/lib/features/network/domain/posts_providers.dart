import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../profile/domain/profile_providers.dart';
import '../data/posts_repository.dart';
import 'post_model.dart';

final postsRepositoryProvider = Provider<PostsRepository>(
  (ref) => PostsRepository(Supabase.instance.client),
);

final postsNotifierProvider =
    AsyncNotifierProvider<PostsNotifier, List<PostModel>>(
  PostsNotifier.new,
);

class PostsNotifier extends AsyncNotifier<List<PostModel>> {
  @override
  Future<List<PostModel>> build() async {
    final profile = ref.read(currentProfileProvider).valueOrNull;
    return ref
        .read(postsRepositoryProvider)
        .getPosts(currentProfileId: profile?.id);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  Future<void> createPost({
    required String type,
    required String title,
    required String content,
    required List<String> tags,
    File? mediaFile,
    bool isVideo = false,
  }) async {
    final profile = ref.read(currentProfileProvider).valueOrNull;
    if (profile == null) return;

    final repo = ref.read(postsRepositoryProvider);

    String? mediaUrl;
    String? mediaType;
    if (mediaFile != null) {
      // Let upload failures bubble up so the UI can surface them to the user.
      mediaUrl = await repo.uploadPostMedia(
        profileId: profile.id,
        file: mediaFile,
        isVideo: isVideo,
      );
      mediaType = isVideo ? 'video' : 'image';
    }

    try {
      final newPost = await repo.createPost(
        authorId: profile.id,
        type: type,
        title: title,
        content: content,
        tags: tags,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
      );
      state = AsyncData([newPost, ...state.valueOrNull ?? []]);
    } catch (_) {
      // Don't enter error state on a single failed create — keep existing posts
    }
  }

  /// Adjusts a post's comment count locally (DB triggers keep the
  /// authoritative value; this keeps the feed in sync without a refetch).
  void bumpCommentCount(String postId, int delta) {
    final current = state.valueOrNull ?? [];
    final idx = current.indexWhere((p) => p.id == postId);
    if (idx == -1) return;
    final post = current[idx];
    final newList = List<PostModel>.from(current)
      ..[idx] = post.copyWith(
        commentsCount: (post.commentsCount + delta).clamp(0, 1 << 30),
      );
    state = AsyncData(newList);
  }

  Future<void> toggleLike(String postId) async {
    final profile = ref.read(currentProfileProvider).valueOrNull;
    if (profile == null) return;

    final current = state.valueOrNull ?? [];
    final idx = current.indexWhere((p) => p.id == postId);
    if (idx == -1) return;

    final post = current[idx];
    final repo = ref.read(postsRepositoryProvider);

    final updated = post.isLikedByMe
        ? post.copyWith(
            isLikedByMe: false,
            likesCount: (post.likesCount - 1).clamp(0, 999999),
          )
        : post.copyWith(
            isLikedByMe: true,
            likesCount: post.likesCount + 1,
          );

    final newList = List<PostModel>.from(current)..[idx] = updated;
    state = AsyncData(newList);

    try {
      if (post.isLikedByMe) {
        await repo.unlikePost(postId, profile.id);
      } else {
        await repo.likePost(postId, profile.id);
      }
    } catch (_) {
      // Revert optimistic update on failure
      final revertList = List<PostModel>.from(state.valueOrNull ?? []);
      final ri = revertList.indexWhere((p) => p.id == postId);
      if (ri != -1) revertList[ri] = post;
      state = AsyncData(revertList);
    }
  }

  Future<void> toggleBookmark(String postId) async {
    final profile = ref.read(currentProfileProvider).valueOrNull;
    if (profile == null) return;

    final current = state.valueOrNull ?? [];
    final idx = current.indexWhere((p) => p.id == postId);
    if (idx == -1) return;

    final post = current[idx];
    final repo = ref.read(postsRepositoryProvider);

    final updated = post.copyWith(isBookmarkedByMe: !post.isBookmarkedByMe);
    state = AsyncData(List<PostModel>.from(current)..[idx] = updated);

    try {
      if (post.isBookmarkedByMe) {
        await repo.unbookmarkPost(postId, profile.id);
      } else {
        await repo.bookmarkPost(postId, profile.id);
      }
      // Keep the Saved tab fresh.
      ref.invalidate(savedPostsProvider);
    } catch (_) {
      final revertList = List<PostModel>.from(state.valueOrNull ?? []);
      final ri = revertList.indexWhere((p) => p.id == postId);
      if (ri != -1) revertList[ri] = post;
      state = AsyncData(revertList);
    }
  }
}

/// Posts the current user has saved, newest-saved first.
final savedPostsProvider =
    FutureProvider.autoDispose<List<PostModel>>((ref) async {
  final profile = ref.watch(currentProfileProvider).valueOrNull;
  if (profile == null) return [];
  return ref.read(postsRepositoryProvider).getBookmarkedPosts(profile.id);
});
