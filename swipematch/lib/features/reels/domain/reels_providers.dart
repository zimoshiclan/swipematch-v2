import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/domain/post_model.dart';
import '../../network/domain/posts_providers.dart';

/// A person's recent posts/achievements — the Reels fallback shown when they
/// have no intro video. Keyed by the author's profile id.
final authorPostsProvider = FutureProvider.autoDispose
    .family<List<PostModel>, String>((ref, authorId) {
  return ref.read(postsRepositoryProvider).getPostsByAuthor(authorId);
});
