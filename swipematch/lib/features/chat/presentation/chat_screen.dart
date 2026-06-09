import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/chat_providers.dart';
import '../domain/message_model.dart';
import '../../match/domain/match_providers.dart';
import '../../profile/domain/profile_providers.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/utils/haptics.dart';

class ChatScreen extends HookConsumerWidget {
  const ChatScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final scrollController = useScrollController();
    final messagesAsync = ref.watch(chatNotifierProvider(matchId));
    final matchAsync = ref.watch(matchDetailProvider(matchId));
    final profileAsync = ref.watch(currentProfileProvider);
    final myId = profileAsync.valueOrNull?.userId; // auth UUID matches messages.sender_id

    // Scroll to bottom on new messages
    useEffect(() {
      messagesAsync.whenData((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      });
      return null;
    }, [messagesAsync]);

    Future<void> send() async {
      final text = controller.text.trim();
      if (text.isEmpty) return;
      AppHaptics.buttonTap();
      controller.clear();
      await ref.read(chatNotifierProvider(matchId).notifier).sendMessage(text);
    }

    final jobTitle = matchAsync.valueOrNull?.jobTitle ?? 'Chat';
    final companyName = matchAsync.valueOrNull?.companyName;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.canPop() ? context.pop() : context.go('/feed'),
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary, size: 20),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(jobTitle, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
            if (companyName != null)
              Text(companyName,
                  style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => Center(
                child: Text('Failed to load messages', style: AppTextStyles.bodyMd),
              ),
              data: (messages) => messages.isEmpty
                  ? _EmptyChat(jobTitle: jobTitle)
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, i) {
                        return _MessageBubble(
                          message: messages[i],
                          isMe: messages[i].senderId == myId,
                        );
                      },
                    ),
            ),
          ),
          _MessageInput(controller: controller, onSend: send),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMe});
  final MessageModel message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: AppTextStyles.bodyMd.copyWith(
                color: isMe ? Colors.white : AppColors.textPrimary,
              ),
            ),
            if (message.aiAssisted) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome_rounded,
                      size: 10,
                      color: isMe
                          ? Colors.white.withValues(alpha: 0.7)
                          : AppColors.accent),
                  const SizedBox(width: 3),
                  Text(
                    'AI assisted',
                    style: AppTextStyles.label.copyWith(
                      fontSize: 10,
                      color: isMe
                          ? Colors.white.withValues(alpha: 0.7)
                          : AppColors.accent,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.05),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput({required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
        top: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.surface, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTextStyles.bodyMd,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyChat extends StatelessWidget {
  const _EmptyChat({required this.jobTitle});
  final String jobTitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
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
              child: const Icon(Icons.chat_bubble_outline_rounded,
                  color: AppColors.primary, size: 32),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Start the conversation!', style: AppTextStyles.headlineSm, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'You matched on $jobTitle. Send the first message.',
              style: AppTextStyles.bodyMd,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
