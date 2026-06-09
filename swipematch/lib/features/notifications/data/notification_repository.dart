// ignore_for_file: unused_field
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/constants/supabase_constants.dart';

class NotificationRepository {
  NotificationRepository(this._messaging);

  final FirebaseMessaging _messaging;
  final _supabase = Supabase.instance.client;

  Future<String?> requestPermissionAndGetToken() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      return null;
    }

    return _messaging.getToken();
  }

  Future<void> saveFcmToken(String profileId, String token) async {
    await _supabase
        .from(SupabaseConstants.profiles)
        .update({'fcm_token': token}).eq('id', profileId);
  }

  void listenToForegroundMessages(
    void Function(RemoteMessage message) onMessage,
  ) {
    FirebaseMessaging.onMessage.listen(onMessage);
  }

  Future<void> subscribeToUserTopic(String userId) async {
    final topic = 'user_${userId.replaceAll('-', '_')}';
    await _messaging.subscribeToTopic(topic);
  }
}
