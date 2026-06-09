import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/notification_model.dart';
import '../../../shared/constants/supabase_constants.dart';

class AppNotificationsRepository {
  AppNotificationsRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<List<NotificationModel>> fetchNotifications(String profileId) async {
    final data = await _supabase
        .from(SupabaseConstants.appNotifications)
        .select()
        .eq('profile_id', profileId)
        .order('created_at', ascending: false)
        .limit(50);

    return (data as List).map((n) => NotificationModel.fromJson(n)).toList();
  }

  Future<void> markRead(String notificationId) async {
    await _supabase
        .from(SupabaseConstants.appNotifications)
        .update({'is_read': true}).eq('id', notificationId);
  }

  Future<void> markAllRead(String profileId) async {
    await _supabase
        .from(SupabaseConstants.appNotifications)
        .update({'is_read': true}).eq('profile_id', profileId);
  }

  Future<int> unreadCount(String profileId) async {
    final result = await _supabase
        .from(SupabaseConstants.appNotifications)
        .select('id')
        .eq('profile_id', profileId)
        .eq('is_read', false);
    return (result as List).length;
  }
}
