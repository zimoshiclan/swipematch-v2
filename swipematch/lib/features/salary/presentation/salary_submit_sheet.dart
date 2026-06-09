import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/salary_providers.dart';
import '../../profile/domain/profile_providers.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';

class SalarySubmitSheet extends HookConsumerWidget {
  const SalarySubmitSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = useTextEditingController();
    final role = useTextEditingController();
    final salary = useTextEditingController();
    final currency = useState<String>('USD');
    final city = useTextEditingController();
    final country = useTextEditingController();
    final isSubmitting = useState(false);
    final error = useState<String?>(null);

    Future<void> submit() async {
      error.value = null;

      final parsed = int.tryParse(salary.text.replaceAll(',', '').trim());
      if (company.text.trim().isEmpty ||
          role.text.trim().isEmpty ||
          parsed == null ||
          parsed <= 0) {
        error.value = 'Company, role and a valid annual salary are required.';
        return;
      }

      final profile = ref.read(currentProfileProvider).valueOrNull;
      if (profile == null) {
        error.value = 'You must be signed in.';
        return;
      }

      isSubmitting.value = true;
      try {
        await ref.read(salaryRepositoryProvider).submit(
              reporterId: profile.id,
              companyName: company.text,
              roleTitle: role.text,
              salary: parsed,
              currency: currency.value,
              city: city.text.trim().isEmpty ? null : city.text.trim(),
              country: country.text.trim().isEmpty ? null : country.text.trim(),
            );
        if (context.mounted) Navigator.of(context).pop();
      } catch (e) {
        error.value = 'Submission failed. Try again.';
      } finally {
        isSubmitting.value = false;
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Add a salary report', style: AppTextStyles.headlineSm),
            const SizedBox(height: 4),
            Text(
              'Anonymous. We never show your name. Help others know their worth.',
              style: AppTextStyles.bodyMd,
            ),
            const SizedBox(height: AppSpacing.lg),
            _Field(controller: company, hint: 'Company name', icon: Icons.business_rounded),
            const SizedBox(height: AppSpacing.sm),
            _Field(controller: role, hint: 'Role title', icon: Icons.work_outline_rounded),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _Field(
                    controller: salary,
                    hint: 'Annual salary',
                    icon: Icons.payments_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _CurrencyDropdown(
                    value: currency.value,
                    onChanged: (v) => currency.value = v,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _Field(
                    controller: city,
                    hint: 'City (optional)',
                    icon: Icons.location_city_rounded,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _Field(
                    controller: country,
                    hint: 'Country (optional)',
                    icon: Icons.public_rounded,
                  ),
                ),
              ],
            ),
            if (error.value != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(error.value!,
                  style:
                      AppTextStyles.label.copyWith(color: AppColors.danger)),
            ],
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'Submit anonymously',
                isLoading: isSubmitting.value,
                onPressed: isSubmitting.value ? null : submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
  });
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyLg,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
        hintText: hint,
        hintStyle: AppTextStyles.bodyMd,
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _CurrencyDropdown extends StatelessWidget {
  const _CurrencyDropdown({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  static const _options = ['USD', 'EUR', 'GBP', 'AED', 'BHD', 'SAR', 'INR'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppColors.surface,
          isExpanded: true,
          style: AppTextStyles.bodyLg,
          items: _options
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
