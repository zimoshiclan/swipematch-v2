import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/profile_model.dart';
import '../domain/profile_providers.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';

class ProfileEditSheet extends HookConsumerWidget {
  const ProfileEditSheet({super.key, required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameCtrl = useTextEditingController(text: profile.name);
    final headlineCtrl =
        useTextEditingController(text: profile.headline ?? '');
    final bioCtrl = useTextEditingController(text: profile.bio ?? '');
    final skillInputCtrl = useTextEditingController();
    final expCtrl = useTextEditingController(
        text: profile.experienceYears?.toString() ?? '');
    final salaryMinCtrl =
        useTextEditingController(text: profile.salaryMin?.toString() ?? '');
    final salaryMaxCtrl =
        useTextEditingController(text: profile.salaryMax?.toString() ?? '');

    final workingTowardCtrl =
        useTextEditingController(text: profile.workingToward ?? '');
    final currentlyLearningCtrl =
        useTextEditingController(text: profile.currentlyLearning ?? '');

    final skills = useState<List<String>>(List.from(profile.skills));
    final workValues = useState<List<String>>(List.from(profile.workValues));
    final workStyle = useState<String>(
      ['remote', 'hybrid', 'on_site'].contains(profile.workStyle)
          ? profile.workStyle!
          : '',
    );
    final currency = useState<String>(
      ['USD', 'EUR', 'GBP', 'SAR', 'AED'].contains(profile.currency)
          ? profile.currency
          : 'USD',
    );
    final timeline = useState<String>(profile.jobSearchTimeline ?? '');
    final saving = useState(false);

    void addSkill() {
      final s = skillInputCtrl.text.trim();
      if (s.isEmpty || skills.value.contains(s)) return;
      skills.value = [...skills.value, s];
      skillInputCtrl.clear();
    }

    Future<void> save() async {
      final name = nameCtrl.text.trim();
      if (name.isEmpty) return;
      saving.value = true;
      try {
        final expYears = int.tryParse(expCtrl.text.trim());
        final salMin = int.tryParse(salaryMinCtrl.text.trim());
        final salMax = int.tryParse(salaryMaxCtrl.text.trim());

        int score = 0;
        if (name.isNotEmpty) score += 20;
        final bio =
            bioCtrl.text.trim().isEmpty ? null : bioCtrl.text.trim();
        if (bio != null) score += 15;
        if (skills.value.isNotEmpty) score += 20;
        if (salMin != null && salMax != null) score += 15;
        if (workStyle.value.isNotEmpty) score += 15;
        if (expYears != null) score += 15;

        final workingToward = workingTowardCtrl.text.trim().isEmpty
            ? null
            : workingTowardCtrl.text.trim();
        final currentlyLearning = currentlyLearningCtrl.text.trim().isEmpty
            ? null
            : currentlyLearningCtrl.text.trim();

        await ref.read(profileRepositoryProvider).updateProfile(
          profileId: profile.id,
          updates: {
            'name': name,
            'headline': headlineCtrl.text.trim().isEmpty
                ? null
                : headlineCtrl.text.trim(),
            'bio': bio,
            'skills': skills.value,
            'experience_years': expYears,
            'salary_min': salMin,
            'salary_max': salMax,
            'currency': currency.value,
            'work_style':
                workStyle.value.isEmpty ? null : workStyle.value,
            'job_search_timeline':
                timeline.value.isEmpty ? null : timeline.value,
            'working_toward': workingToward,
            'currently_learning': currentlyLearning,
            'work_values': workValues.value,
            'profile_completion': score.clamp(0, 100),
          },
        );
        ref.invalidate(currentProfileProvider);
        if (context.mounted) Navigator.of(context).pop();
      } finally {
        saving.value = false;
      }
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Edit Profile',
                        style: AppTextStyles.headlineSm),
                    saving.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary),
                          )
                        : TextButton(
                            onPressed: save,
                            child: Text(
                              'Save',
                              style: AppTextStyles.bodyMd.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              const Divider(color: AppColors.surface, height: 1),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionLabel('Basic info'),
                      const SizedBox(height: AppSpacing.sm),
                      _Field(
                          ctrl: nameCtrl,
                          label: 'Full name',
                          hint: 'Your full name'),
                      const SizedBox(height: AppSpacing.sm),
                      _Field(
                          ctrl: headlineCtrl,
                          label: 'Headline',
                          hint: 'e.g. Senior Flutter Developer'),
                      const SizedBox(height: AppSpacing.sm),
                      _Field(
                        ctrl: bioCtrl,
                        label: 'Bio',
                        hint: 'A short introduction...',
                        maxLines: 3,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _SectionLabel('Becoming'),
                      const SizedBox(height: 4),
                      Text(
                        'Who you\'re working toward being — not where you\'ve been',
                        style: AppTextStyles.label
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _Field(
                        ctrl: workingTowardCtrl,
                        label: 'What I\'m working toward',
                        hint:
                            'e.g. Leading a product team in climate tech',
                        maxLines: 2,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _Field(
                        ctrl: currentlyLearningCtrl,
                        label: 'What I\'m learning right now',
                        hint: 'e.g. Systems design, Arabic, watercolour',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _WorkValuesField(
                        values: workValues.value,
                        onChanged: (v) => workValues.value = v,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _SectionLabel('Skills'),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: _Field(
                              ctrl: skillInputCtrl,
                              label: '',
                              hint: 'Add a skill (e.g. Flutter)',
                              onSubmitted: (_) => addSkill(),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          GestureDetector(
                            onTap: addSkill,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.add,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                      if (skills.value.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.xs,
                          runSpacing: AppSpacing.xs,
                          children: skills.value
                              .map((s) => _RemovableChip(
                                    label: s,
                                    onRemove: () => skills.value = skills
                                        .value
                                        .where((x) => x != s)
                                        .toList(),
                                  ))
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      _SectionLabel('Experience'),
                      const SizedBox(height: AppSpacing.sm),
                      _Field(
                        ctrl: expCtrl,
                        label: 'Years of experience',
                        hint: '0',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _SectionLabel('Compensation'),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: _Field(
                              ctrl: salaryMinCtrl,
                              label: 'Min salary',
                              hint: '50000',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: _Field(
                              ctrl: salaryMaxCtrl,
                              label: 'Max salary',
                              hint: '100000',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _DropdownField(
                        label: 'Currency',
                        value: currency.value,
                        items: const {
                          'USD': 'USD — US Dollar',
                          'EUR': 'EUR — Euro',
                          'GBP': 'GBP — British Pound',
                          'SAR': 'SAR — Saudi Riyal',
                          'AED': 'AED — UAE Dirham',
                        },
                        onChanged: (v) => currency.value = v ?? 'USD',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _SectionLabel('Work preferences'),
                      const SizedBox(height: AppSpacing.sm),
                      _DropdownField(
                        label: 'Work style',
                        value: workStyle.value,
                        items: const {
                          '': 'Select work style',
                          'remote': 'Remote',
                          'hybrid': 'Hybrid',
                          'on_site': 'On-site',
                        },
                        onChanged: (v) => workStyle.value = v ?? '',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _DropdownField(
                        label: 'Job search timeline',
                        value: timeline.value,
                        items: const {
                          '': 'Just exploring',
                          '1_month': 'Ready in 1 month',
                          '3_months': 'Ready in 3 months',
                          '6_months': 'Ready in 6 months',
                        },
                        onChanged: (v) => timeline.value = v ?? '',
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) =>
      Text(label, style: AppTextStyles.headlineSm);
}

class _Field extends StatelessWidget {
  const _Field({
    required this.ctrl,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.onSubmitted,
  });

  final TextEditingController ctrl;
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label,
              style: AppTextStyles.label
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
        ],
        TextField(
          controller: ctrl,
          style: AppTextStyles.bodyMd,
          maxLines: maxLines,
          minLines: 1,
          keyboardType: keyboardType,
          textInputAction:
              maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final Map<String, String> items;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.label
                .copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            dropdownColor: AppColors.surface,
            style: AppTextStyles.bodyMd,
            items: items.entries
                .map((e) => DropdownMenuItem<String>(
                      value: e.key,
                      child:
                          Text(e.value, style: AppTextStyles.bodyMd),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

const _kWorkValues = [
  'Impact-driven',
  'Honest culture',
  'Continuous learning',
  'Work-life balance',
  'Mission-driven',
  'Flat hierarchy',
  'Mentorship',
  'Autonomy',
  'Collaboration',
  'Innovation',
  'Purpose over pay',
  'Fast-paced',
];

class _WorkValuesField extends StatelessWidget {
  const _WorkValuesField({required this.values, required this.onChanged});
  final List<String> values;
  final void Function(List<String>) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Work values (pick up to 4)',
          style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: _kWorkValues.map((v) {
            final selected = values.contains(v);
            return GestureDetector(
              onTap: () {
                if (selected) {
                  onChanged(values.where((x) => x != v).toList());
                } else if (values.length < 4) {
                  onChanged([...values, v]);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 5),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : AppColors.card,
                    width: 1,
                  ),
                ),
                child: Text(
                  v,
                  style: AppTextStyles.label.copyWith(
                    color: selected ? Colors.white : AppColors.textSecondary,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _RemovableChip extends StatelessWidget {
  const _RemovableChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style:
                  AppTextStyles.label.copyWith(color: AppColors.primary)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close_rounded,
                size: 14, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
