import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../domain/app_notifications_providers.dart';
import '../domain/notification_model.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(appNotificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary, size: 20),
        ),
        title: Text('Notifications', style: AppTextStyles.headlineSm),
        actions: [
          TextButton(
            onPressed: () =>
                ref.read(appNotificationsProvider.notifier).markAllRead(),
            child: Text(
              'Mark all read',
              style:
                  AppTextStyles.label.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child:
              Text('Failed to load notifications', style: AppTextStyles.bodyMd),
        ),
        data: (notifications) => notifications.isEmpty
            ? const _EmptyNotifications()
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: notifications.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.xs),
                itemBuilder: (context, i) => _NotificationTile(
                  notification: notifications[i],
                ).animate().fadeIn(delay: (i * 40).ms, duration: 200.ms),
              ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final n = notification;
    return Container(
      decoration: BoxDecoration(
        color: n.isRead
            ? AppColors.surface
            : AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: n.isRead
            ? null
            : Border.all(
                color: AppColors.primary.withValues(alpha: 0.2), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_iconFor(n.type), color: AppColors.primary, size: 20),
        ),
        title: Text(
          n.title,
          style: AppTextStyles.bodyMd.copyWith(
            fontWeight: n.isRead ? FontWeight.normal : FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (n.body.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(n.body, style: AppTextStyles.label),
            ],
            const SizedBox(height: 4),
            Text(
              _formatTime(n.createdAt),
              style: AppTextStyles.label
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        trailing: n.isRead
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
      ),
    );
  }

  IconData _iconFor(String type) => switch (type) {
        'match' => Icons.favorite_rounded,
        'message' => Icons.chat_bubble_rounded,
        'view' => Icons.visibility_rounded,
        'ghost' => Icons.timer_off_rounded,
        'post_like' => Icons.favorite_rounded,
        'post_comment' => Icons.mode_comment_rounded,
        'comment_like' => Icons.favorite_rounded,
        'comment_reply' => Icons.reply_rounded,
        _ => Icons.notifications_rounded,
      };

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(dt);
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none_rounded,
                color: AppColors.primary, size: 32),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('All caught up!',
              style: AppTextStyles.headlineSm, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'New activity will appear here.',
            style: AppTextStyles.bodyMd,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
