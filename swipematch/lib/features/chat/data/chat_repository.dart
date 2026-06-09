// ignore_for_file: unused_field
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/message_model.dart';
import '../../../shared/constants/supabase_constants.dart';

class ChatRepository {
  ChatRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<List<MessageModel>> fetchMessages(String matchId) async {
    final response = await _supabase
        .from(SupabaseConstants.messages)
        .select()
        .eq('match_id', matchId)
        .order('created_at', ascending: true);

    return (response as List)
        .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  Future<void> sendMessage({
    required String matchId,
    required String senderId,
    required String content,
  }) async {
    await _supabase.from(SupabaseConstants.messages).insert({
      'match_id': matchId,
      'sender_id': senderId,
      'content': content,
      'ai_assisted': false,
    });

    await _maybeMarkEmployerFirstResponse(matchId: matchId, senderUserId: senderId);
  }

  // Ghost tracker: when an employer's user sends the first message on a match,
  // stamp first_response_at so the ghost-sweep job stops counting it.
  Future<void> _maybeMarkEmployerFirstResponse({
    required String matchId,
    required String senderUserId,
  }) async {
    try {
      final match = await _supabase
          .from(SupabaseConstants.matches)
          .select('id, first_response_at, company_id, companies(employer_id, profiles!companies_employer_id_fkey(user_id))')
          .eq('id', matchId)
          .maybeSingle();

      if (match == null || match['first_response_at'] != null) return;

      final company = match['companies'] as Map<String, dynamic>?;
      final employerProfile = company?['profiles'] as Map<String, dynamic>?;
      final employerUserId = employerProfile?['user_id'] as String?;
      if (employerUserId == null || employerUserId != senderUserId) return;

      await _supabase
          .from(SupabaseConstants.matches)
          .update({'first_response_at': DateTime.now().toUtc().toIso8601String()})
          .eq('id', matchId);
    } catch (_) {
      // Best-effort — never block a message send on ghost-tracker bookkeeping.
    }
  }

  RealtimeChannel subscribeToMessages({
    required String matchId,
    required void Function(MessageModel) onNewMessage,
  }) {
    return _supabase
        .channel('messages_$matchId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: SupabaseConstants.messages,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'match_id',
            value: matchId,
          ),
          callback: (payload) {
            final newRow = payload.newRecord;
            if (newRow.isNotEmpty) {
              onNewMessage(MessageModel.fromJson(newRow));
            }
          },
        )
        .subscribe();
  }
}
