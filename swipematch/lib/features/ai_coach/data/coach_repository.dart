// ignore_for_file: unused_field
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/constants/supabase_constants.dart';

class CoachRepository {
  CoachRepository(this._dio);

  final Dio _dio;

  final _supabase = Supabase.instance.client;

  Future<String> askCoach({
    required String profileId,
    required String question,
    List<Map<String, String>> conversationHistory = const [],
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        SupabaseConstants.fnAiCoach,
        body: {
          'profileId': profileId,
          'question': question,
          'conversationHistory': conversationHistory,
        },
      );
      final data = response.data as Map<String, dynamic>?;
      return data?['reply'] as String? ?? 'Something went wrong. Try again.';
    } catch (e) {
      return 'Could not reach AI coach. Please check your connection.';
    }
  }
}
