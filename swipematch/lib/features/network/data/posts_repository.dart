import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../shared/constants/supabase_constants.dart';
import '../domain/post_model.dart';

class PostsRepository {
  PostsRepository(this._supabase);
  final SupabaseClient _supabase;

  /// Uploads an image or video for a post and returns its public URL.
  /// Stored under `<profile_id>/<timestamp>.<ext>` to satisfy storage RLS.
  Future<String> uploadPostMedia({
    required String profileId,
    required File file,
    required bool isVideo,
  }) async {
    final ext = file.path.split('.').last.toLowerCase();
    final objectPath =
        '$profileId/${DateTime.now().millisecondsSinceEpoch}.$ext';

    await _supabase.storage.from(SupabaseConstants.postMediaBucket).upload(
          objectPath,
          file,
          fileOptions: FileOptions(
            cacheControl: '3600',
            upsert: true,
            contentType: _mimeFor(ext, isVideo),
          ),
        );

    return _supabase.storage
        .from(SupabaseConstants.postMediaBucket)
        .getPublicUrl(objectPath);
  }

  String _mimeFor(String ext, bool isVideo) {
    if (isVideo) {
      return switch (ext) {
        'mov' => 'video/quicktime',
        'webm' => 'video/webm',
        _ => 'video/mp4',
      };
    }
    return switch (ext) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      _ => 'image/jpeg',
    };
  }

  Future<List<PostModel>> getPosts({
    String? currentProfileId,
    int limit = 30,
    DateTime? before,
  }) async {
    var builder = _supabase
        .from(SupabaseConstants.posts)
        .select('*, profiles!author_id(name, avatar_url, ai_readiness_score)');

    if (before != null) {
      builder = builder.lt('created_at', before.toIso8601String());
    }

    final rows = await builder.order('created_at', ascending: false).limit(limit) as List;

    Set<String> likedIds = {};
    Set<String> bookmarkedIds = {};
    if (currentProfileId != null && rows.isNotEmpty) {
      final postIds = rows.map((r) => r['id'] as String).toList();
      final likes = await _supabase
          .from(SupabaseConstants.postLikes)
          .select('post_id')
          .eq('profile_id', currentProfileId)
          .inFilter('post_id', postIds) as List;
      likedIds = likes.map((l) => l['post_id'] as String).toSet();

      final bookmarks = await _supabase
          .from(SupabaseConstants.postBookmarks)
          .select('post_id')
          .eq('profile_id', currentProfileId)
          .inFilter('post_id', postIds) as List;
      bookmarkedIds = bookmarks.map((b) => b['post_id'] as String).toSet();
    }

    return rows.map((r) => _mapRow(r, likedIds, bookmarkedIds)).toList();
  }

  /// A person's own recent posts — used as the Room/Reels fallback when they
  /// have no intro video. Achievements/wins/insights surface first.
  Future<List<PostModel>> getPostsByAuthor(String authorId, {int limit = 5}) async {
    final rows = await _supabase
        .from(SupabaseConstants.posts)
        .select('*, profiles!author_id(name, avatar_url, ai_readiness_score)')
        .eq('author_id', authorId)
        .order('created_at', ascending: false)
        .limit(limit) as List;

    const highlight = {'achievement', 'win', 'insight'};
    final posts = rows.map((r) => _mapRow(r, const {}, const {})).toList();
    posts.sort((a, b) {
      final ah = highlight.contains(a.type) ? 0 : 1;
      final bh = highlight.contains(b.type) ? 0 : 1;
      return ah != bh ? ah - bh : b.createdAt.compareTo(a.createdAt);
    });
    return posts;
  }

  /// Posts the given profile has bookmarked, newest-saved first.
  Future<List<PostModel>> getBookmarkedPosts(String profileId) async {
    final bookmarkRows = await _supabase
        .from(SupabaseConstants.postBookmarks)
        .select('post_id, created_at')
        .eq('profile_id', profileId)
        .order('created_at', ascending: false) as List;

    if (bookmarkRows.isEmpty) return [];

    final orderedIds = bookmarkRows.map((b) => b['post_id'] as String).toList();

    final postRows = await _supabase
        .from(SupabaseConstants.posts)
        .select('*, profiles!author_id(name, avatar_url, ai_readiness_score)')
        .inFilter('id', orderedIds) as List;

    final likes = await _supabase
        .from(SupabaseConstants.postLikes)
        .select('post_id')
        .eq('profile_id', profileId)
        .inFilter('post_id', orderedIds) as List;
    final likedIds = likes.map((l) => l['post_id'] as String).toSet();

    final byId = {
      for (final r in postRows)
        (r as Map)['id'] as String: _mapRow(r, likedIds, orderedIds.toSet()),
    };
    // Preserve bookmark recency order.
    return [
      for (final id in orderedIds)
        if (byId[id] != null) byId[id]!,
    ];
  }

  Future<PostModel> createPost({
    required String authorId,
    required String type,
    required String title,
    required String content,
    required List<String> tags,
    String? mediaUrl,
    String? mediaType,
  }) async {
    final row = await _supabase
        .from(SupabaseConstants.posts)
        .insert({
          'author_id': authorId,
          'type': type,
          'title': title,
          'content': content,
          'tags': tags,
          if (mediaUrl != null) 'media_url': mediaUrl,
          if (mediaType != null) 'media_type': mediaType,
        })
        .select('*, profiles!author_id(name, avatar_url, ai_readiness_score)')
        .single();

    return _mapRow(row, {}, {});
  }

  Future<void> bookmarkPost(String postId, String profileId) async {
    await _supabase.from(SupabaseConstants.postBookmarks).insert({
      'post_id': postId,
      'profile_id': profileId,
    });
  }

  Future<void> unbookmarkPost(String postId, String profileId) async {
    await _supabase
        .from(SupabaseConstants.postBookmarks)
        .delete()
        .eq('post_id', postId)
        .eq('profile_id', profileId);
  }

  Future<void> likePost(String postId, String profileId) async {
    await _supabase.from(SupabaseConstants.postLikes).insert({
      'post_id': postId,
      'profile_id': profileId,
    });
    await _supabase.rpc('increment_post_likes', params: {'p_post_id': postId});
  }

  Future<void> unlikePost(String postId, String profileId) async {
    await _supabase
        .from(SupabaseConstants.postLikes)
        .delete()
        .eq('post_id', postId)
        .eq('profile_id', profileId);
    await _supabase.rpc('decrement_post_likes', params: {'p_post_id': postId});
  }

  PostModel _mapRow(
    dynamic raw,
    Set<String> likedIds,
    Set<String> bookmarkedIds,
  ) {
    final map = Map<String, dynamic>.from(raw as Map);
    final author = map['profiles'] as Map<String, dynamic>?;
    return PostModel.fromJson({
      'id': map['id'],
      'author_id': map['author_id'],
      'author_name': author?['name'] ?? 'Anonymous',
      'author_avatar_url': author?['avatar_url'],
      'author_ai_readiness_score': author?['ai_readiness_score'],
      'type': map['type'],
      'title': map['title'],
      'content': map['content'],
      'media_url': map['media_url'],
      'media_type': map['media_type'],
      'tags': (map['tags'] as List?)?.cast<String>() ?? [],
      'likes_count': map['likes_count'] ?? 0,
      'comments_count': map['comments_count'] ?? 0,
      'is_liked_by_me': likedIds.contains(map['id'] as String),
      'is_bookmarked_by_me': bookmarkedIds.contains(map['id'] as String),
      'created_at': map['created_at'],
    });
  }
}
