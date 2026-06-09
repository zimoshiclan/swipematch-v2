import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../shared/constants/supabase_constants.dart';
import '../domain/comment_model.dart';

class CommentsRepository {
  CommentsRepository(this._supabase);
  final SupabaseClient _supabase;

  Future<List<CommentModel>> getComments(
    String postId, {
    String? currentProfileId,
  }) async {
    final rows = await _supabase
        .from(SupabaseConstants.postComments)
        .select('*, profiles!author_id(name, avatar_url, ai_readiness_score)')
        .eq('post_id', postId)
        .order('created_at', ascending: true) as List;

    Set<String> likedIds = {};
    if (currentProfileId != null && rows.isNotEmpty) {
      final commentIds = rows.map((r) => r['id'] as String).toList();
      final likes = await _supabase
          .from(SupabaseConstants.commentLikes)
          .select('comment_id')
          .eq('profile_id', currentProfileId)
          .inFilter('comment_id', commentIds) as List;
      likedIds = likes.map((l) => l['comment_id'] as String).toSet();
    }

    return rows.map((r) => _mapRow(r, likedIds)).toList();
  }

  Future<CommentModel> addComment({
    required String postId,
    required String authorId,
    required String content,
    String? parentId,
  }) async {
    final row = await _supabase
        .from(SupabaseConstants.postComments)
        .insert({
          'post_id': postId,
          'author_id': authorId,
          'content': content,
          if (parentId != null) 'parent_id': parentId,
        })
        .select('*, profiles!author_id(name, avatar_url, ai_readiness_score)')
        .single();

    return _mapRow(row, {});
  }

  Future<void> likeComment(String commentId, String profileId) async {
    await _supabase.from(SupabaseConstants.commentLikes).insert({
      'comment_id': commentId,
      'profile_id': profileId,
    });
  }

  Future<void> unlikeComment(String commentId, String profileId) async {
    await _supabase
        .from(SupabaseConstants.commentLikes)
        .delete()
        .eq('comment_id', commentId)
        .eq('profile_id', profileId);
  }

  CommentModel _mapRow(dynamic raw, Set<String> likedIds) {
    final map = Map<String, dynamic>.from(raw as Map);
    final author = map['profiles'] as Map<String, dynamic>?;
    return CommentModel.fromJson({
      'id': map['id'],
      'post_id': map['post_id'],
      'author_id': map['author_id'],
      'author_name': author?['name'] ?? 'Anonymous',
      'author_avatar_url': author?['avatar_url'],
      'author_ai_readiness_score': author?['ai_readiness_score'],
      'parent_id': map['parent_id'],
      'content': map['content'],
      'likes_count': map['likes_count'] ?? 0,
      'is_liked_by_me': likedIds.contains(map['id'] as String),
      'created_at': map['created_at'],
    });
  }
}
