import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/coach_repository.dart';
import '../../profile/domain/profile_providers.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/utils/haptics.dart';

final _coachRepoProvider = Provider<CoachRepository>(
  (ref) => CoachRepository(Dio()),
);

class CoachPanel extends HookConsumerWidget {
  const CoachPanel({super.key, required this.matchId, this.initialPrompt});

  final String matchId;
  final String? initialPrompt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final scrollController = useScrollController();
    final profileAsync = ref.watch(currentProfileProvider);
    final messages = useState<List<_CoachMsg>>([]);
    final isLoading = useState(false);

    // Welcome message + optional auto-send of initialPrompt
    useEffect(() {
      messages.value = [
        const _CoachMsg(
          text: "Hi! I'm your AI career coach. Ask me anything about this match, how to prepare, or how to improve your profile.",
          isAi: true,
        ),
      ];
      return null;
    }, const []);

    Future<void> sendText(String text) async {
      if (text.isEmpty || isLoading.value) return;

      final profile = profileAsync.valueOrNull;
      if (profile == null) return;

      AppHaptics.buttonTap();
      messages.value = [...messages.value, _CoachMsg(text: text, isAi: false)];
      isLoading.value = true;

      final history = messages.value
          .skip(1)
          .map((m) => {'role': m.isAi ? 'assistant' : 'user', 'content': m.text})
          .toList();

      final repo = ref.read(_coachRepoProvider);
      final reply = await repo.askCoach(
        profileId: profile.id,
        question: text,
        conversationHistory: history,
      );

      isLoading.value = false;
      messages.value = [...messages.value, _CoachMsg(text: reply, isAi: true)];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }

    // Auto-send initialPrompt on first open
    useEffect(() {
      if (initialPrompt != null && initialPrompt!.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          sendText(initialPrompt!);
        });
      }
      return null;
    }, const []);

    Future<void> send() async {
      final text = controller.text.trim();
      controller.clear();
      await sendText(text);
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded,
                      color: Colors.white, size: 18),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI Career Coach',
                        style: AppTextStyles.bodyMd
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text('Powered by Claude',
                        style: AppTextStyles.label
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.card, height: 24),
          // Messages
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: messages.value.length + (isLoading.value ? 1 : 0),
              itemBuilder: (context, i) {
                if (i == messages.value.length && isLoading.value) {
                  return const _ThinkingBubble();
                }
                final msg = messages.value[i];
                return _CoachBubble(msg: msg);
              },
            ),
          ),
          // Input
          _CoachInput(
            controller: controller,
            onSend: send,
            isLoading: isLoading.value,
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}

class _CoachMsg {
  const _CoachMsg({required this.text, required this.isAi});
  final String text;
  final bool isAi;
}

class _CoachBubble extends StatelessWidget {
  const _CoachBubble({required this.msg});
  final _CoachMsg msg;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: msg.isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: msg.isAi ? AppColors.card : AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isAi ? 4 : 16),
            bottomRight: Radius.circular(msg.isAi ? 16 : 4),
          ),
        ),
        child: Text(
          msg.text,
          style: AppTextStyles.bodyMd.copyWith(
            color: msg.isAi ? AppColors.textPrimary : Colors.white,
          ),
        ),
      ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.05),
    );
  }
}

class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome_rounded,
                color: AppColors.primary, size: 14),
            const SizedBox(width: 6),
            Text('Thinking...',
                style: AppTextStyles.label
                    .copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ).animate().fadeIn(duration: 200.ms),
    );
  }
}

class _CoachInput extends StatelessWidget {
  const _CoachInput({
    required this.controller,
    required this.onSend,
    required this.isLoading,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTextStyles.bodyMd,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: const InputDecoration(
                hintText: 'Ask your coach...',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isLoading ? AppColors.surface : AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading ? null : onSend,
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        )
                      : const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
