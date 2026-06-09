import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/employer_providers.dart';
import '../../match/domain/match_model.dart';
import '../../../router/app_router.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/ghost_score_badge.dart';
import '../../../shared/widgets/match_score_badge.dart';

const _stages = [
  AppConstants.statusNewMatch,
  AppConstants.statusContacted,
  AppConstants.statusInterview,
  AppConstants.statusOffer,
  AppConstants.statusHired,
];

const _stageLabels = {
  AppConstants.statusNewMatch: 'New',
  AppConstants.statusContacted: 'Contacted',
  AppConstants.statusInterview: 'Interview',
  AppConstants.statusOffer: 'Offer',
  AppConstants.statusHired: 'Hired 🎉',
};

const _stageColors = {
  AppConstants.statusNewMatch: AppColors.primary,
  AppConstants.statusContacted: AppColors.accent,
  AppConstants.statusInterview: AppColors.matchGold,
  AppConstants.statusOffer: AppColors.hotBadge,
  AppConstants.statusHired: AppColors.accent,
};

class PipelineScreen extends HookConsumerWidget {
  const PipelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pipelineAsync = ref.watch(pipelineNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: context.canPop()
            ? IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    color: AppColors.textPrimary, size: 20),
              )
            : null,
        title: Text('Pipeline', style: AppTextStyles.headlineSm),
      ),
      body: pipelineAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Text('Failed to load pipeline', style: AppTextStyles.bodyMd),
        ),
        data: (matches) => _PipelineBoard(matches: matches, ref: ref),
      ),
    );
  }
}

class _PipelineBoard extends StatelessWidget {
  const _PipelineBoard({required this.matches, required this.ref});
  final List<MatchModel> matches;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: _stages.length,
      itemBuilder: (context, i) {
        final stage = _stages[i];
        final stageMatches = matches.where((m) => m.status == stage).toList();
        return _PipelineColumn(
          stage: stage,
          matches: stageMatches,
          ref: ref,
        );
      },
    );
  }
}

class _PipelineColumn extends StatelessWidget {
  const _PipelineColumn({
    required this.stage,
    required this.matches,
    required this.ref,
  });

  final String stage;
  final List<MatchModel> matches;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final color = _stageColors[stage] ?? AppColors.primary;
    final label = _stageLabels[stage] ?? stage;

    return DragTarget<MatchModel>(
      onWillAcceptWithDetails: (details) => details.data.status != stage,
      onAcceptWithDetails: (details) {
        ref
            .read(pipelineNotifierProvider.notifier)
            .updateStatus(details.data.id, stage);
      },
      builder: (context, candidateData, rejectedData) {
        final hovering = candidateData.isNotEmpty;
        return Container(
          width: 200,
          margin: const EdgeInsets.only(right: AppSpacing.md),
          decoration: BoxDecoration(
            color: hovering ? color.withValues(alpha: 0.06) : null,
            borderRadius: BorderRadius.circular(12),
            border: hovering
                ? Border.all(color: color.withValues(alpha: 0.6), width: 2)
                : null,
          ),
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.bodyMd.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${matches.length}',
                      style: AppTextStyles.label.copyWith(color: color),
                    ),
                  ],
                ),
              )
                  .animate(
                    delay: Duration(milliseconds: _stages.indexOf(stage) * 80),
                  )
                  .fadeIn(duration: 300.ms),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, i) {
                    final match = matches[i];
                    return LongPressDraggable<MatchModel>(
                      data: match,
                      delay: const Duration(milliseconds: 180),
                      feedback: Material(
                        color: Colors.transparent,
                        child: Opacity(
                          opacity: 0.85,
                          child: SizedBox(
                            width: 184,
                            child: _PipelineCard(
                              match: match,
                              currentStage: stage,
                              dragging: true,
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: _PipelineCard(
                          match: match,
                          currentStage: stage,
                        ),
                      ),
                      child: _PipelineCard(
                        match: match,
                        currentStage: stage,
                      )
                          .animate(
                            delay: Duration(
                              milliseconds:
                                  _stages.indexOf(stage) * 80 + i * 50,
                            ),
                          )
                          .fadeIn(duration: 250.ms)
                          .slideY(begin: 0.05),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PipelineCard extends StatelessWidget {
  const _PipelineCard({
    required this.match,
    required this.currentStage,
    this.dragging = false,
  });

  final MatchModel match;
  final String currentStage;
  final bool dragging;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: dragging ? null : () => context.push(AppRoutes.chatPath(match.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          boxShadow: dragging
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    match.candidateName ?? 'Candidate',
                    style: AppTextStyles.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                MatchScoreBadge(score: match.matchScore),
              ],
            ),
            if (match.jobTitle != null) ...[
              const SizedBox(height: 4),
              Text(
                match.jobTitle!,
                style: AppTextStyles.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            // Ghost timer — only meaningful for new matches with no reply yet.
            if (currentStage == AppConstants.statusNewMatch) ...[
              const SizedBox(height: AppSpacing.xs),
              GhostCountdownChip(
                matchCreatedAt: match.createdAt,
                firstResponseAt: match.firstResponseAt,
                ghostedAt: match.ghostedAt,
              ),
            ],
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.drag_indicator_rounded,
                    size: 12, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'Hold to drag',
                  style: AppTextStyles.label.copyWith(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
