import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/chat_repository.dart';
import 'message_model.dart';
import '../../profile/domain/profile_providers.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(Supabase.instance.client);
});

final chatNotifierProvider = AutoDisposeAsyncNotifierProviderFamily<
    ChatNotifier, List<MessageModel>, String>(ChatNotifier.new);

class ChatNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<MessageModel>, String> {
  @override
  Future<List<MessageModel>> build(String arg) async {
    final repo = ref.read(chatRepositoryProvider);
    final messages = await repo.fetchMessages(arg);

    final channel = repo.subscribeToMessages(
      matchId: arg,
      onNewMessage: (msg) {
        final current = state.valueOrNull ?? [];
        if (current.any((m) => m.id == msg.id)) return;
        state = AsyncData([...current, msg]);
      },
    );

    ref.onDispose(() => channel.unsubscribe());

    return messages;
  }

  Future<void> sendMessage(String content) async {
    final profile = await ref.read(currentProfileProvider.future);
    if (profile == null || content.trim().isEmpty) return;

    final repo = ref.read(chatRepositoryProvider);
    final matchId = arg;

    // Optimistic update — sender_id must be auth user UUID (FK → auth.users + RLS)
    final optimistic = MessageModel(
      id: 'opt_${DateTime.now().millisecondsSinceEpoch}',
      matchId: matchId,
      senderId: profile.userId,
      content: content.trim(),
      createdAt: DateTime.now(),
    );

    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, optimistic]);

    await repo.sendMessage(
      matchId: matchId,
      senderId: profile.userId,
      content: content.trim(),
    );
  }
}
