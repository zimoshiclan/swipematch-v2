import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth/domain/auth_providers.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/role_selector_screen.dart';
import '../features/chat/presentation/chat_screen.dart';
import '../features/home/presentation/main_shell.dart';
import '../features/match/presentation/match_detail_screen.dart';
import '../features/match/presentation/match_reveal_screen.dart';
import '../features/onboarding/presentation/candidate_onboarding_screen.dart';
import '../features/onboarding/presentation/employer_onboarding_screen.dart';
import '../features/onboarding/presentation/onboarding_welcome_screen.dart';
import '../features/profile/domain/profile_providers.dart';
import '../features/salary/presentation/salary_truth_screen.dart';

class AppRoutes {
  static const String auth = '/auth';
  static const String home = '/home';
  static const String onboardingWelcome = '/onboarding/welcome';
  static const String onboardingRole = '/onboarding/role';
  static const String onboardingCandidate = '/onboarding/candidate';
  static const String onboardingEmployer = '/onboarding/employer';
  static const String matchReveal = '/match/:id';
  static const String chat = '/match/:id/chat';
  static const String matchDetail = '/match/:id/detail';
  static const String salary = '/salary';

  // Legacy aliases — all navigate back to the shell
  static const String feed = home;
  static const String employerFeed = home;
  static const String matches = home;
  static const String profile = home;
  static const String employerPipeline = home;

  static String matchRevealPath(String id) => '/match/$id';
  static String chatPath(String id) => '/match/$id/chat';
  static String matchDetailPath(String id) => '/match/$id/detail';
}

final routerNotifierProvider =
    NotifierProvider<RouterNotifier, void>(RouterNotifier.new);

class RouterNotifier extends Notifier<void> implements Listenable {
  VoidCallback? _routerListener;

  @override
  void build() {
    ref.listen(authStateStreamProvider, (_, __) => _routerListener?.call());
    ref.listen(currentProfileProvider, (_, __) => _routerListener?.call());
  }

  @override
  void addListener(VoidCallback listener) => _routerListener = listener;

  @override
  void removeListener(VoidCallback listener) {
    if (_routerListener == listener) _routerListener = null;
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isAuthenticated = session != null;
    final loc = state.matchedLocation;

    final isOnAuth = loc == AppRoutes.auth;
    final isOnOnboarding = loc.startsWith('/onboarding');

    if (!isAuthenticated) {
      return isOnAuth ? null : AppRoutes.auth;
    }

    final profileAsync = ref.read(currentProfileProvider);
    if (profileAsync.isLoading) return null;

    final profile = profileAsync.valueOrNull;

    if (profile == null) {
      return isOnOnboarding ? null : AppRoutes.onboardingWelcome;
    }

    // Bounce auth/onboarding screens to home once profile exists
    if (isOnAuth || loc == AppRoutes.onboardingRole ||
        loc == AppRoutes.onboardingWelcome) {
      return AppRoutes.home;
    }

    return null;
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider.notifier);
  // If a restored session already exists (Supabase loaded it from secure
  // storage during initialize()), skip the login screen entirely.
  final hasSession = Supabase.instance.client.auth.currentSession != null;

  return GoRouter(
    initialLocation: hasSession ? AppRoutes.home : AppRoutes.auth,
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingWelcome,
        builder: (context, state) => const OnboardingWelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingRole,
        builder: (context, state) => const RoleSelectorScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingCandidate,
        builder: (context, state) => const CandidateOnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingEmployer,
        builder: (context, state) => const EmployerOnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainShell(),
      ),
      GoRoute(
        path: AppRoutes.salary,
        builder: (context, state) => const SalaryTruthScreen(),
      ),
      GoRoute(
        path: '/match/:id',
        builder: (context, state) => MatchRevealScreen(
          matchId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'chat',
            builder: (context, state) => ChatScreen(
              matchId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: 'detail',
            builder: (context, state) => MatchDetailScreen(
              matchId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
    ],
  );
});
