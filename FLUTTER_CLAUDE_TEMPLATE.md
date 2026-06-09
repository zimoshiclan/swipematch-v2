# Flutter App — Claude Instructions

> Copy this file into any new Flutter project as `CLAUDE.md` and fill in the
> project-specific sections at the top. Everything below the divider is universal.

---

## Project overview
<!-- Fill in: what the app does, target users, key flows -->

## Tech stack
<!-- Adjust versions as needed -->
- Flutter stable (latest)
- Dart null-safe
- State: flutter_riverpod + hooks_riverpod + flutter_hooks
- Navigation: go_router
- Backend: <!-- Supabase / Firebase / custom API -->
- Models: freezed + json_serializable + build_runner
- Local storage: hive_flutter or shared_preferences
- Secure storage: flutter_secure_storage
- HTTP: dio (for REST) or supabase_flutter client
- Images: cached_network_image
- Loading states: shimmer

---

## Folder structure

```
lib/
  main.dart               # bootstrap only: runApp, Supabase.init, Hive.init
  app.dart                # MaterialApp.router, theme, ProviderScope
  router/
    app_router.dart       # all GoRoute definitions
  features/
    <feature>/
      data/
        <feature>_repository.dart   # all remote/db calls
      domain/
        <feature>_model.dart        # freezed model
        <feature>_state.dart        # AsyncNotifier + @riverpod provider
      presentation/
        <feature>_screen.dart       # HookConsumerWidget, layout only
        widgets/                    # reusable widgets scoped to this feature
  shared/
    theme/
      app_colors.dart
      app_text_styles.dart
      app_spacing.dart
      app_theme.dart
    widgets/              # truly app-wide reusable widgets
    utils/
    constants/
      app_constants.dart  # ALL user-visible strings live here
```

Never put Supabase/API calls in widgets. Never put UI logic in repositories.

---

## Models — freezed

Every domain model uses freezed. No exceptions.

```dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    String? avatarUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

After writing or changing any freezed model: tell the user to run
`dart run build_runner build --delete-conflicting-outputs`
Do NOT run this command yourself.

---

## State — Riverpod

One `AsyncNotifier` per feature. Keep business logic here, not in widgets.

```dart
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  Future<UserModel> build() => ref.read(userRepositoryProvider).fetchUser();

  Future<void> updateName(String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(userRepositoryProvider).updateName(name),
    );
  }
}
```

Prefer `ref.watch` for reactive data, `ref.read` inside callbacks/handlers.
Never put `ref.read` at the top of `build()` — use `ref.watch` or pass
dependencies through the notifier.

---

## Navigation — go_router

All routes in `router/app_router.dart`. Use `extra` for complex objects.

```dart
GoRoute(
  path: '/profile/:id',
  builder: (context, state) => ProfileScreen(
    id: state.pathParameters['id']!,
    user: state.extra as UserModel?,
  ),
),
```

Navigate: `context.go('/path')` for replace, `context.push('/path')` for stack.
Never use `Navigator.push` — go_router only.

---

## UI rules

**All screens extend HookConsumerWidget** — no StatefulWidget unless absolutely forced by a third-party package.

```dart
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    return state.when(
      data: (data) => _Body(data: data),
      loading: () => const _LoadingSkeleton(),
      error: (e, _) => _ErrorView(onRetry: () => ref.invalidate(homeNotifierProvider)),
    );
  }
}
```

**Loading state** → shimmer skeleton, never a blank screen or spinner alone
**Error state** → actionable widget with retry button and human-readable message
**Empty state** → illustrated empty state with a clear call to action
**Dark mode** → always use `Theme.of(context)` colors and `ColorScheme`, never hardcoded hex
**Strings** → all user-visible text in `app_constants.dart`, never inline

---

## Haptic feedback

Use `HapticFeedback` from `services/flutter` — import `flutter/services.dart`.

| Action | Haptic |
|---|---|
| Primary button tap | `selectionClick()` |
| Swipe / swipe action | `mediumImpact()` |
| Destructive action | `heavyImpact()` |
| Success / reward | `heavyImpact()` |
| Toggle / checkbox | `selectionClick()` |

---

## Code quality (non-negotiable)

- **No `var`** — use `final` or explicit types
- **No `dynamic`** — use generics, `Object`, or typed models
- **No `!` force-unwrap** unless you can prove non-null in the same scope
- **No hardcoded strings** in widgets
- **No hardcoded colors** — use theme
- **`const` everywhere possible** — constructors, literals, widgets
- **No `async` in `initState`** — use `ref.listen` or `useEffect` hook
- **Check `mounted`** before using `context` after any `await`
- **No comments** unless the WHY is genuinely non-obvious (a hidden constraint, a workaround, a subtle invariant). Never comment the WHAT.
- **No half-finished implementations** — every method is complete or it does not exist
- **No extra features** — implement exactly what was asked

---

## Repository pattern

```dart
// Good — typed, all Supabase in the repository
class UserRepository {
  final SupabaseClient _client;
  UserRepository(this._client);

  Future<UserModel> fetchUser(String id) async {
    final data = await _client.from('users').select().eq('id', id).single();
    return UserModel.fromJson(data);
  }
}

// Provide it
@riverpod
UserRepository userRepository(Ref ref) =>
    UserRepository(Supabase.instance.client);
```

Never call `Supabase.instance.client` from a widget or a notifier directly.

---

## Error handling

Define typed exceptions in `shared/utils/app_exceptions.dart`.
Repositories throw typed exceptions. Notifiers catch and wrap with `AsyncError`.
Widgets read `AsyncValue` and show the error widget — never raw exception messages to users.

```dart
class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}
```

---

## Performance

- Wrap large lists in `ListView.builder`, never `Column` + `.map()`
- Use `cached_network_image` for every remote image — never `Image.network`
- Avoid rebuilding the whole tree: scope `ref.watch` to the smallest widget
- Use `RepaintBoundary` around complex animated widgets
- Prefer `const` widgets at the leaf level

---

## Naming conventions

| Thing | Convention | Example |
|---|---|---|
| Files | `snake_case.dart` | `user_profile_screen.dart` |
| Classes | `PascalCase` | `UserProfileScreen` |
| Variables / params | `camelCase` | `userName` |
| Constants | `camelCase` (no ALL_CAPS) | `maxRetryCount` |
| Private members | `_camelCase` | `_fetchData()` |
| Providers | `<noun>Provider` | `userNotifierProvider` |
| Repositories | `<Feature>Repository` | `AuthRepository` |
| Screens | `<Feature>Screen` | `LoginScreen` |
| Widgets | descriptive noun | `AvatarCircle`, `PrimaryButton` |

---

## Commands (tell the user to run — never run yourself)

| When | Command |
|---|---|
| After adding/changing a freezed model | `dart run build_runner build --delete-conflicting-outputs` |
| After adding a @riverpod provider (codegen) | `dart run build_runner build --delete-conflicting-outputs` |
| To run the app | `flutter run` |
| To run tests | `flutter test` |
| To analyze | `flutter analyze` |
| To format | `dart format lib/` |

---

## What NOT to do

- Do not call APIs from widgets
- Do not use `setState` in screens — use Riverpod
- Do not use `Navigator.push` — use go_router
- Do not store sensitive data in SharedPreferences — use flutter_secure_storage
- Do not import one feature's widgets into another feature — use shared/widgets
- Do not create abstract base classes or mixins unless 3+ concrete uses exist
- Do not wrap everything in try/catch — let typed exceptions propagate to the notifier
- Do not use `BuildContext` across async gaps without `mounted` check
- Do not run `build_runner` or `flutter` commands — tell the user to run them
- Do not commit `.env` files or API keys
- Do not design for hypothetical future requirements — build what is asked
