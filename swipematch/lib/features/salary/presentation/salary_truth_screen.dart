import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/salary_providers.dart';
import '../domain/salary_report_model.dart';
import 'salary_submit_sheet.dart';
import '../../../router/app_router.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/utils/currency_utils.dart';
import '../../../shared/widgets/primary_button.dart';

class SalaryTruthScreen extends HookConsumerWidget {
  const SalaryTruthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyCtrl = useTextEditingController();
    final roleCtrl = useTextEditingController();
    final aggregateAsync = ref.watch(salaryAggregateProvider);

    void runSearch() {
      ref.read(salaryQueryProvider.notifier).state = SalaryQuery(
        company: companyCtrl.text,
        role: roleCtrl.text,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.home),
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary, size: 20),
        ),
        title: Text('Salary truth', style: AppTextStyles.headlineSm),
        actions: [
          TextButton.icon(
            onPressed: () => _openSubmit(context, ref),
            icon: const Icon(Icons.add_rounded,
                color: AppColors.accent, size: 18),
            label: Text(
              'Contribute',
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.accent),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Intro(),
            const SizedBox(height: AppSpacing.lg),
            _SearchFields(
              companyCtrl: companyCtrl,
              roleCtrl: roleCtrl,
              onSearch: runSearch,
            ),
            const SizedBox(height: AppSpacing.lg),
            aggregateAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary)),
              ),
              error: (e, _) => Text(
                'Failed to load reports. Try again.',
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.danger),
              ),
              data: (agg) {
                if (agg == null) {
                  return _EmptyOrPrompt(
                    onContribute: () => _openSubmit(context, ref),
                  );
                }
                return _Results(aggregate: agg);
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            _TrendingCompanies(
              onTap: (name) {
                companyCtrl.text = name;
                runSearch();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openSubmit(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const SalarySubmitSheet(),
    ).then((_) => ref.invalidate(salaryAggregateProvider));
  }
}

class _Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💰', style: TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crowdsourced. Verified. Anonymous.',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppConstants.salaryTruthBannerSubtitle,
                  style: AppTextStyles.bodyMd,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}

class _SearchFields extends StatelessWidget {
  const _SearchFields({
    required this.companyCtrl,
    required this.roleCtrl,
    required this.onSearch,
  });

  final TextEditingController companyCtrl;
  final TextEditingController roleCtrl;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Field(
          controller: companyCtrl,
          icon: Icons.business_rounded,
          hint: 'Company name (optional)',
          onSubmitted: (_) => onSearch(),
        ),
        const SizedBox(height: AppSpacing.sm),
        _Field(
          controller: roleCtrl,
          icon: Icons.work_outline_rounded,
          hint: 'Role title (optional)',
          onSubmitted: (_) => onSearch(),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(label: 'See the data', onPressed: onSearch),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.icon,
    required this.hint,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      style: AppTextStyles.bodyLg,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
        hintText: hint,
        hintStyle: AppTextStyles.bodyMd,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _EmptyOrPrompt extends StatelessWidget {
  const _EmptyOrPrompt({required this.onContribute});
  final VoidCallback onContribute;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_rounded,
              color: AppColors.textSecondary, size: 32),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppConstants.salaryTruthEmpty,
            style: AppTextStyles.bodyMd,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(label: 'Add a salary report', onPressed: onContribute),
        ],
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.aggregate});
  final SalaryAggregate aggregate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${aggregate.count} verified reports',
          style: AppTextStyles.label,
        ),
        const SizedBox(height: AppSpacing.sm),
        _StatGrid(aggregate: aggregate),
        const SizedBox(height: AppSpacing.lg),
        Text('Recent reports', style: AppTextStyles.headlineSm),
        const SizedBox(height: AppSpacing.sm),
        ...aggregate.sampleReports.map((r) => _ReportTile(report: r)),
      ],
    ).animate().fadeIn(duration: 250.ms);
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.aggregate});
  final SalaryAggregate aggregate;

  @override
  Widget build(BuildContext context) {
    final currency = aggregate.currency;
    return Column(
      children: [
        _BigStat(
          label: 'Median',
          amount: aggregate.median,
          currency: currency,
          highlight: true,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(child: _SmallStat(label: '25th pct', amount: aggregate.p25, currency: currency)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: _SmallStat(label: '75th pct', amount: aggregate.p75, currency: currency)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(child: _SmallStat(label: 'Min', amount: aggregate.min, currency: currency)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: _SmallStat(label: 'Max', amount: aggregate.max, currency: currency)),
          ],
        ),
      ],
    );
  }
}

class _BigStat extends StatelessWidget {
  const _BigStat({
    required this.label,
    required this.amount,
    required this.currency,
    this.highlight = false,
  });

  final String label;
  final int amount;
  final String currency;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: highlight
            ? LinearGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.15),
                  AppColors.primary.withValues(alpha: 0.15),
                ],
              )
            : null,
        color: highlight ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight
              ? AppColors.accent.withValues(alpha: 0.4)
              : AppColors.card,
        ),
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.label),
          const SizedBox(height: 4),
          Text(
            CurrencyUtils.format(amount, currencyCode: currency),
            style: AppTextStyles.display.copyWith(
              color: highlight ? AppColors.accent : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  const _SmallStat({
    required this.label,
    required this.amount,
    required this.currency,
  });

  final String label;
  final int amount;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.label),
          const SizedBox(height: 4),
          Text(
            CurrencyUtils.format(amount, currencyCode: currency),
            style: AppTextStyles.bodyLg.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({required this.report});
  final SalaryReportModel report;

  @override
  Widget build(BuildContext context) {
    final loc = [report.city, report.country].whereType<String>().join(', ');
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${report.roleTitle} @ ${report.companyName}',
                  style: AppTextStyles.bodyMd
                      .copyWith(color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (loc.isNotEmpty)
                  Text(loc, style: AppTextStyles.label),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyUtils.format(report.salary, currencyCode: report.currency),
                style: AppTextStyles.bodyLg.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (report.verified)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded,
                        color: AppColors.accent, size: 12),
                    const SizedBox(width: 3),
                    Text('Verified',
                        style: AppTextStyles.label
                            .copyWith(color: AppColors.accent)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendingCompanies extends HookConsumerWidget {
  const _TrendingCompanies({required this.onTap});
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trending = ref.watch(trendingCompaniesProvider);
    return trending.maybeWhen(
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Most reported', style: AppTextStyles.headlineSm),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: items
                  .map(
                    (e) => GestureDetector(
                      onTap: () => onTap(e.company),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.card),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              e.company,
                              style: AppTextStyles.bodyMd
                                  .copyWith(color: AppColors.textPrimary),
                            ),
                            const SizedBox(width: 6),
                            Text('· ${e.count}',
                                style: AppTextStyles.label),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
