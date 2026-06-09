import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/match_repository.dart';
import 'match_model.dart';

final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  return MatchRepository(Supabase.instance.client);
});

final matchDetailProvider =
    FutureProvider.autoDispose.family<MatchModel?, String>(
  (ref, matchId) async {
    return ref.read(matchRepositoryProvider).fetchMatch(matchId);
  },
);

final matchListProvider =
    FutureProvider.autoDispose.family<List<MatchModel>, String>(
  (ref, candidateId) async {
    return ref.read(matchRepositoryProvider).fetchMatches(candidateId);
  },
);
