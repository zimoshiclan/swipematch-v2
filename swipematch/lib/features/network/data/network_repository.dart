import 'package:supabase_flutter/supabase_flutter.dart';

import '../../profile/domain/profile_model.dart';

class NetworkRepository {
  NetworkRepository(this._supabase);
  final SupabaseClient _supabase;

  Future<List<ProfileModel>> getSuggestions(
    String currentProfileId, {
    int limit = 30,
  }) async {
    // Fetch IDs the user has already requested
    final sentRows = await _supabase
        .from('connections')
        .select('receiver_id')
        .eq('requester_id', currentProfileId);
    final alreadySent = (sentRows as List)
        .map((e) => e['receiver_id'] as String)
        .toSet();

    final response = await _supabase
        .from('profiles')
        .select()
        .neq('id', currentProfileId)
        .eq('passive_mode', false)
        .order('profile_completion', ascending: false)
        .limit(limit);

    return (response as List)
        .map((e) => ProfileModel.fromJson(e as Map<String, dynamic>))
        .where((p) => !alreadySent.contains(p.id))
        .toList();
  }

  Future<List<ProfileModel>> getConnections(String profileId) async {
    // Accepted connections where the user is either the requester or receiver
    final asRequester = await _supabase
        .from('connections')
        .select('receiver_id, profiles!receiver_id(*)')
        .eq('requester_id', profileId)
        .eq('status', 'accepted');

    final asReceiver = await _supabase
        .from('connections')
        .select('requester_id, profiles!requester_id(*)')
        .eq('receiver_id', profileId)
        .eq('status', 'accepted');

    final fromRequester = (asRequester as List).map(
        (e) => ProfileModel.fromJson(e['profiles'] as Map<String, dynamic>));
    final fromReceiver = (asReceiver as List).map(
        (e) => ProfileModel.fromJson(e['profiles'] as Map<String, dynamic>));

    return [...fromRequester, ...fromReceiver];
  }

  Future<List<ProfileModel>> getPendingRequests(String profileId) async {
    final response = await _supabase
        .from('connections')
        .select('requester_id, profiles!requester_id(*)')
        .eq('receiver_id', profileId)
        .eq('status', 'pending');

    return (response as List)
        .map((e) =>
            ProfileModel.fromJson(e['profiles'] as Map<String, dynamic>))
        .toList();
  }

  Future<void> sendRequest(String fromProfileId, String toProfileId) async {
    await _supabase.from('connections').upsert(
      {
        'requester_id': fromProfileId,
        'receiver_id': toProfileId,
        'status': 'pending',
      },
      onConflict: 'requester_id,receiver_id',
      ignoreDuplicates: true,
    );
  }

  Future<void> acceptRequest(
      String fromProfileId, String toProfileId) async {
    await _supabase
        .from('connections')
        .update({'status': 'accepted'})
        .eq('requester_id', fromProfileId)
        .eq('receiver_id', toProfileId);
  }

  // Resolve (or create) the match id backing the chat with a connected person.
  // Works from either side of the connection. See migration 014.
  Future<String> getOrCreateMatchId(String otherProfileId) async {
    final result = await _supabase.rpc(
      'get_or_create_person_match',
      params: {'p_other_profile_id': otherProfileId},
    );
    return result as String;
  }
}
