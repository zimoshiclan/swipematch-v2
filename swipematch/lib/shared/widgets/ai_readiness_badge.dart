import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AiReadinessBadge extends StatelessWidget {
  const AiReadinessBadge({
    super.key,
    required this.skills,
    this.large = false,
  });

  final List<String> skills;
  final bool large;

  static const _aiKeywords = {
    'ai', 'ml', 'machine learning', 'deep learning', 'tensorflow', 'pytorch',
    'nlp', 'natural language', 'data science', 'llm', 'large language',
    'prompt engineering', 'gpt', 'gemini', 'langchain', 'neural network',
    'computer vision', 'generative', 'mlops', 'vector', 'automation',
    'reinforcement', 'transformer', 'diffusion', 'stable diffusion',
  };

  static bool isAiReady(List<String> skills) => skills.any(
      (s) => _aiKeywords.any((kw) => s.toLowerCase().contains(kw)));

  static double computeScore(List<String> skills) {
    final matches = skills
        .where((s) => _aiKeywords.any((kw) => s.toLowerCase().contains(kw)))
        .length;
    return (matches / 4.0).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    if (!isAiReady(skills)) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 10 : 6,
        vertical: large ? 4 : 2,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: large ? 13 : 10,
          ),
          SizedBox(width: large ? 4 : 3),
          Text(
            'AI Ready',
            style: (large ? AppTextStyles.label : AppTextStyles.label).copyWith(
              color: Colors.white,
              fontSize: large ? 12 : 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
