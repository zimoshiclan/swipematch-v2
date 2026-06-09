import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../data/credential_storage.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/utils/haptics.dart';
import '../../../shared/widgets/primary_button.dart';
import '../domain/auth_providers.dart';

final _credStorage = CredentialStorage();

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final activeTab = useState(0);

    useEffect(() {
      void listener() => activeTab.value = tabController.index;
      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xl),
            _Logo()
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.15, end: 0, curve: Curves.easeOut),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Build the career you\'re working toward',
              style: AppTextStyles.bodyMd
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: AppSpacing.xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: _TabBar(controller: tabController),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  _LoginTab(onSwitchToSignUp: () => tabController.animateTo(1)),
                  _SignUpTab(onSwitchToLogin: () => tabController.animateTo(0)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Tab bar
// ─────────────────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  const _TabBar({required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: AppTextStyles.bodyMd
            .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
        unselectedLabelStyle: AppTextStyles.bodyMd
            .copyWith(color: AppColors.textSecondary),
        tabs: const [
          Tab(text: 'Log In'),
          Tab(text: 'Sign Up'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Logo
// ─────────────────────────────────────────────────────────

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 24),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text('SwipeMatch', style: AppTextStyles.headlineLg),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Log In tab
// ─────────────────────────────────────────────────────────

class _LoginTab extends HookConsumerWidget {
  const _LoginTab({required this.onSwitchToSignUp});
  final VoidCallback onSwitchToSignUp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailCtrl = useTextEditingController();
    final passCtrl = useTextEditingController();
    final obscure = useState(true);
    final rememberMe = useState(false);
    final isLoading = useState(false);
    final errorMsg = useState<String?>(null);
    final showMagicLink = useState(false);

    // Load saved credentials on first build
    useEffect(() {
      _credStorage.load().then((saved) {
        if (saved != null) {
          emailCtrl.text = saved.email;
          passCtrl.text = saved.password;
          rememberMe.value = true;
        }
      });
      return null;
    }, []);

    Future<void> login() async {
      final email = emailCtrl.text.trim();
      final password = passCtrl.text;
      if (email.isEmpty || password.isEmpty) {
        errorMsg.value = 'Please enter your email and password.';
        return;
      }
      AppHaptics.buttonTap();
      isLoading.value = true;
      errorMsg.value = null;
      try {
        await ref.read(authRepositoryProvider).signInWithPassword(
              email: email,
              password: password,
            );
        if (rememberMe.value) {
          await _credStorage.save(email: email, password: password);
        } else {
          await _credStorage.clear();
        }
      } on AuthException catch (e) {
        errorMsg.value = _friendlyAuthError(e.message);
      } catch (_) {
        errorMsg.value = 'Something went wrong. Please try again.';
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> forgotPassword() async {
      final email = emailCtrl.text.trim();
      if (email.isEmpty) {
        errorMsg.value = 'Enter your email above, then tap Forgot Password.';
        return;
      }
      isLoading.value = true;
      errorMsg.value = null;
      try {
        await ref.read(authRepositoryProvider).sendPasswordReset(email);
        errorMsg.value = null;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password reset email sent to $email'),
              backgroundColor: AppColors.accent,
            ),
          );
        }
      } catch (_) {
        errorMsg.value = 'Could not send reset email. Check your address.';
      } finally {
        isLoading.value = false;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!showMagicLink.value) ...[
            _FieldLabel('Email'),
            const SizedBox(height: AppSpacing.xs),
            _EmailField(controller: emailCtrl, onSubmit: () => FocusScope.of(context).nextFocus()),
            const SizedBox(height: AppSpacing.md),
            _FieldLabel('Password'),
            const SizedBox(height: AppSpacing.xs),
            _PasswordField(
              controller: passCtrl,
              obscure: obscure.value,
              onToggle: () => obscure.value = !obscure.value,
              onSubmit: login,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: rememberMe.value,
                    onChanged: (v) => rememberMe.value = v ?? false,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text('Remember me', style: AppTextStyles.label),
                const Spacer(),
                GestureDetector(
                  onTap: forgotPassword,
                  child: Text(
                    'Forgot password?',
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            if (errorMsg.value != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _ErrorText(errorMsg.value!),
            ],
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Log In',
              isLoading: isLoading.value,
              onPressed: login,
            ),
            const SizedBox(height: AppSpacing.lg),
            _OrDivider(),
            const SizedBox(height: AppSpacing.lg),
            _MagicLinkButton(
              onTap: () => showMagicLink.value = true,
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: GestureDetector(
                onTap: onSwitchToSignUp,
                child: Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.textSecondary),
                    children: [
                      TextSpan(
                        text: 'Sign up',
                        style: AppTextStyles.label
                            .copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ] else
            _MagicLinkForm(
              onBack: () => showMagicLink.value = false,
            ).animate().fadeIn(duration: 250.ms),
        ],
      ),
    ).animate(delay: 150.ms).fadeIn(duration: 350.ms);
  }
}

// ─────────────────────────────────────────────────────────
// Sign Up tab
// ─────────────────────────────────────────────────────────

class _SignUpTab extends HookConsumerWidget {
  const _SignUpTab({required this.onSwitchToLogin});
  final VoidCallback onSwitchToLogin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailCtrl = useTextEditingController();
    final passCtrl = useTextEditingController();
    final confirmCtrl = useTextEditingController();
    final obscure = useState(true);
    final obscureConfirm = useState(true);
    final isLoading = useState(false);
    final errorMsg = useState<String?>(null);
    final successMsg = useState<String?>(null);

    Future<void> signUp() async {
      final email = emailCtrl.text.trim();
      final password = passCtrl.text;
      final confirm = confirmCtrl.text;

      if (email.isEmpty || password.isEmpty) {
        errorMsg.value = 'Please fill in all fields.';
        return;
      }
      if (password != confirm) {
        errorMsg.value = 'Passwords do not match.';
        return;
      }
      if (password.length < 8) {
        errorMsg.value = 'Password must be at least 8 characters.';
        return;
      }

      AppHaptics.buttonTap();
      isLoading.value = true;
      errorMsg.value = null;
      successMsg.value = null;
      try {
        await ref.read(authRepositoryProvider).signUpWithPassword(
              email: email,
              password: password,
            );
        // Supabase sends a confirmation email — show success or auto-login
        successMsg.value =
            'Account created! Check your email to confirm, then log in.';
        emailCtrl.clear();
        passCtrl.clear();
        confirmCtrl.clear();
      } on AuthException catch (e) {
        errorMsg.value = _friendlyAuthError(e.message);
      } catch (_) {
        errorMsg.value = 'Sign up failed. Please try again.';
      } finally {
        isLoading.value = false;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel('Email'),
          const SizedBox(height: AppSpacing.xs),
          _EmailField(
              controller: emailCtrl,
              onSubmit: () => FocusScope.of(context).nextFocus()),
          const SizedBox(height: AppSpacing.md),
          _FieldLabel('Password'),
          const SizedBox(height: AppSpacing.xs),
          _PasswordField(
            controller: passCtrl,
            obscure: obscure.value,
            onToggle: () => obscure.value = !obscure.value,
            onSubmit: () => FocusScope.of(context).nextFocus(),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'At least 8 characters',
            style: AppTextStyles.label
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          _FieldLabel('Confirm Password'),
          const SizedBox(height: AppSpacing.xs),
          _PasswordField(
            controller: confirmCtrl,
            obscure: obscureConfirm.value,
            onToggle: () => obscureConfirm.value = !obscureConfirm.value,
            onSubmit: signUp,
            hint: 'Re-enter your password',
          ),
          if (errorMsg.value != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _ErrorText(errorMsg.value!),
          ],
          if (successMsg.value != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.accent, size: 18),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(successMsg.value!,
                        style: AppTextStyles.label
                            .copyWith(color: AppColors.accent)),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Create Account',
            isLoading: isLoading.value,
            onPressed: signUp,
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: GestureDetector(
              onTap: onSwitchToLogin,
              child: Text.rich(
                TextSpan(
                  text: 'Already have an account? ',
                  style: AppTextStyles.label
                      .copyWith(color: AppColors.textSecondary),
                  children: [
                    TextSpan(
                      text: 'Log in',
                      style: AppTextStyles.label
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    ).animate(delay: 150.ms).fadeIn(duration: 350.ms);
  }
}

// ─────────────────────────────────────────────────────────
// Magic link form (inline, replaces login form)
// ─────────────────────────────────────────────────────────

class _MagicLinkForm extends HookConsumerWidget {
  const _MagicLinkForm({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailCtrl = useTextEditingController();
    final codeCtrl = useTextEditingController();
    final isLoading = useState(false);
    final codeSent = useState(false);
    final errorMsg = useState<String?>(null);

    Future<void> sendCode() async {
      final email = emailCtrl.text.trim();
      if (email.isEmpty) return;
      isLoading.value = true;
      errorMsg.value = null;
      try {
        await ref.read(authRepositoryProvider).sendOtp(email);
        codeSent.value = true;
      } catch (_) {
        errorMsg.value = 'Could not send code. Check your email.';
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> verify() async {
      final code = codeCtrl.text.trim();
      if (code.length < 6) return;
      isLoading.value = true;
      errorMsg.value = null;
      try {
        await ref
            .read(authRepositoryProvider)
            .verifyOtp(emailCtrl.text.trim(), code);
      } catch (_) {
        errorMsg.value = 'Invalid code. Please try again.';
        codeCtrl.clear();
      } finally {
        isLoading.value = false;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onBack,
              child: const Icon(Icons.arrow_back_ios_rounded,
                  color: AppColors.textSecondary, size: 18),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text('Magic Link', style: AppTextStyles.headlineSm),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (!codeSent.value) ...[
          Text('Enter your email to receive a sign-in code.',
              style: AppTextStyles.bodyMd
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.md),
          _EmailField(controller: emailCtrl, onSubmit: sendCode),
          if (errorMsg.value != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _ErrorText(errorMsg.value!),
          ],
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
              label: 'Send Code', isLoading: isLoading.value, onPressed: sendCode),
        ] else ...[
          Text('Enter the 6-digit code sent to ${emailCtrl.text.trim()}.',
              style: AppTextStyles.bodyMd
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: codeCtrl,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            autofocus: true,
            maxLength: 6,
            style: AppTextStyles.headlineSm.copyWith(letterSpacing: 8),
            decoration: InputDecoration(
              hintText: '· · · · · ·',
              counterText: '',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (v) {
              if (v.length == 6) verify();
            },
          ),
          if (errorMsg.value != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _ErrorText(errorMsg.value!),
          ],
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
              label: 'Verify Code', isLoading: isLoading.value, onPressed: verify),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Reusable small widgets
// ─────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
      );
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller, required this.onSubmit});
  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => onSubmit(),
      style: AppTextStyles.bodyMd,
      decoration: const InputDecoration(
        hintText: 'you@example.com',
        prefixIcon:
            Icon(Icons.email_outlined, color: AppColors.textSecondary, size: 20),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
    required this.onSubmit,
    this.hint = 'Your password',
  });

  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final VoidCallback onSubmit;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => onSubmit(),
      style: AppTextStyles.bodyMd,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline_rounded,
            color: AppColors.textSecondary, size: 20),
        suffixIcon: GestureDetector(
          onTap: onToggle,
          child: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.surface, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text('or', style: AppTextStyles.label),
        ),
        const Expanded(child: Divider(color: AppColors.surface, thickness: 1)),
      ],
    );
  }
}

class _MagicLinkButton extends StatelessWidget {
  const _MagicLinkButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.surface, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        icon: const Icon(Icons.mark_email_read_outlined,
            size: 20, color: AppColors.textSecondary),
        label: Text('Use magic link instead',
            style: AppTextStyles.bodyMd
                .copyWith(color: AppColors.textSecondary)),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: AppTextStyles.label.copyWith(color: AppColors.danger),
    ).animate().fadeIn(duration: 200.ms).shake(hz: 3, offset: const Offset(4, 0));
  }
}

// ─────────────────────────────────────────────────────────
// Error message helper
// ─────────────────────────────────────────────────────────

String _friendlyAuthError(String raw) {
  final lower = raw.toLowerCase();
  if (lower.contains('invalid login') || lower.contains('invalid credentials')) {
    return 'Incorrect email or password.';
  }
  if (lower.contains('email not confirmed')) {
    return 'Please confirm your email before logging in.';
  }
  if (lower.contains('user already registered')) {
    return 'An account with this email already exists. Log in instead.';
  }
  if (lower.contains('rate limit') || lower.contains('429')) {
    return 'Too many attempts. Wait a moment and try again.';
  }
  if (lower.contains('network') || lower.contains('connection')) {
    return 'No internet connection. Please check your network.';
  }
  return 'Something went wrong. Please try again.';
}
