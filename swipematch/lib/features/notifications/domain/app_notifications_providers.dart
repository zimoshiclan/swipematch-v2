import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/app_notifications_repository.dart';
import 'notification_model.dart';
import '../../profile/domain/profile_providers.dart';

final appNotificationsRepositoryProvider =
    Provider<AppNotificationsRepository>((ref) {
  return AppNotificationsRepository(Supabase.instance.client);
});

final appNotificationsProvider = AutoDisposeAsyncNotifierProvider<
    AppNotificationsNotifier,
    List<NotificationModel>>(AppNotificationsNotifier.new);

class AppNotificationsNotifier
    extends AutoDisposeAsyncNotifier<List<NotificationModel>> {
  @override
  Future<List<NotificationModel>> build() async {
    final profile = await ref.watch(currentProfileProvider.future);
    if (profile == null) return [];
    return ref
        .read(appNotificationsRepositoryProvider)
        .fetchNotifications(profile.id);
  }

  Future<void> markAllRead() async {
    final profile = await ref.read(currentProfileProvider.future);
    if (profile == null) return;
    await ref
        .read(appNotificationsRepositoryProvider)
        .markAllRead(profile.id);
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.map((n) => n.copyWith(isRead: true)).toList());
  }
}

final unreadNotificationCountProvider =
    FutureProvider.autoDispose<int>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  if (profile == null) return 0;
  return ref
      .read(appNotificationsRepositoryProvider)
      .unreadCount(profile.id);
});
