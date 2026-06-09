import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/notifications/data/notification_repository.dart';
import 'features/profile/domain/profile_providers.dart';
import 'router/app_router.dart';
import 'shared/theme/app_theme.dart';

class SwipeMatchApp extends ConsumerWidget {
  const SwipeMatchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    // Update streak and setup notifications when profile first loads
    ref.listen(currentProfileProvider, (prev, next) {
      final profile = next.valueOrNull;
      if (profile == null) return;
      if (prev?.valueOrNull?.id == profile.id) return; // only on first load

      // Fire-and-forget safely — errors are swallowed intentionally
      ref.read(profileRepositoryProvider).updateStreak(profile.id).ignore();
      _setupNotifications(profile.id);
    });

    return MaterialApp.router(
      title: 'The Room',
      theme: AppTheme.dark(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }

  Future<void> _setupNotifications(String profileId) async {
    try {
      final repo = NotificationRepository(FirebaseMessaging.instance);
      final token = await repo.requestPermissionAndGetToken();
      if (token != null) {
        await repo.saveFcmToken(profileId, token);
      }
    } catch (_) {
      // Firebase not configured — safe to skip
    }
  }
}
