import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key, required this.width, required this.height, this.radius = 8});

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.card,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class JobCardSkeleton extends StatelessWidget {
  const JobCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.card,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 48, height: 48, decoration: const BoxDecoration(color: AppColors.card, shape: BoxShape.circle)),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 120, height: 14, color: AppColors.card),
                      const SizedBox(height: 4),
                      Container(width: 80, height: 11, color: AppColors.card),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Container(width: double.infinity, height: 28, color: AppColors.card),
              const SizedBox(height: AppSpacing.sm),
              Container(width: 200, height: 18, color: AppColors.card),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: List.generate(3, (_) => Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: Container(width: 80, height: 28, decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(8))),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
