# SwipeMatch — Flutter Mobile App

## What we're building
A bilateral swipe-based job matching mobile app. Candidates swipe on jobs,
employers swipe on candidates, AI scores and explains every match.
One Flutter codebase for iOS + Android.

## Tech stack
- Mobile: Flutter + Dart (null-safe, latest stable)
- State: Riverpod (flutter_riverpod + hooks_riverpod + flutter_hooks)
- Backend: Supabase (Postgres + Auth + Realtime + Storage + Edge Functions)
- AI: Claude API (claude-sonnet-4-20250514) called ONLY from Supabase 
  Edge Functions — never directly from Flutter
- Navigation: go_router
- Local cache: hive_flutter
- Secure storage: flutter_secure_storage
- Push: firebase_messaging + Supabase DB triggers
- Animations: flutter built-in + rive (match reveal) + lottie (confetti)
- Charts: fl_chart (match score breakdown)
- HTTP: dio (for Edge Function calls)
- Code gen: freezed + json_serializable + build_runner

## Required packages (pubspec.yaml)
dependencies:
  supabase_flutter: ^2.0.0
  flutter_riverpod: ^2.0.0
  hooks_riverpod: ^2.0.0
  flutter_hooks: ^0.20.0
  go_router: ^13.0.0
  flutter_card_swiper: ^7.0.0
  rive: ^0.13.0
  lottie: ^3.0.0
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.0.0
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  firebase_core: ^3.0.0
  firebase_messaging: ^15.0.0
  fl_chart: ^0.68.0
  dio: ^5.0.0
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0
  intl: ^0.19.0

dev_dependencies:
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0

## Folder structure (never deviate from this)
lib/
  main.dart
  app.dart
  router/
    app_router.dart
  features/
    auth/
      data/auth_repository.dart
      domain/auth_state.dart
      domain/user_model.dart
      presentation/login_screen.dart
      presentation/role_selector_screen.dart
    onboarding/
      data/onboarding_repository.dart
      domain/onboarding_state.dart
      presentation/candidate_onboarding_screen.dart
      presentation/employer_onboarding_screen.dart
      presentation/widgets/onboarding_card.dart
    feed/
      data/feed_repository.dart
      domain/job_model.dart
      domain/swipe_model.dart
      domain/feed_state.dart
      presentation/feed_screen.dart
      presentation/widgets/job_card.dart
      presentation/widgets/deck_empty_state.dart
    match/
      data/match_repository.dart
      domain/match_model.dart
      domain/match_reason_model.dart
      presentation/match_reveal_screen.dart
      presentation/match_list_screen.dart
      presentation/match_detail_screen.dart
    chat/
      data/chat_repository.dart
      domain/message_model.dart
      presentation/chat_screen.dart
    employer/
      data/employer_repository.dart
      domain/candidate_card_model.dart
      domain/company_model.dart
      presentation/employer_feed_screen.dart
      presentation/pipeline_screen.dart
    ai_coach/
      data/coach_repository.dart
      presentation/coach_panel.dart
    profile/
      data/profile_repository.dart
      domain/profile_model.dart
      presentation/profile_screen.dart
      presentation/widgets/completion_bar.dart
    notifications/
      data/notification_repository.dart
      domain/notification_model.dart
  shared/
    theme/
      app_colors.dart
      app_text_styles.dart
      app_spacing.dart
      app_theme.dart
    widgets/
      primary_button.dart
      swipe_action_button.dart
      skill_tag.dart
      match_score_badge.dart
      streak_badge.dart
      loading_skeleton.dart
    utils/
      date_utils.dart
      currency_utils.dart
      haptics.dart
    constants/
      app_constants.dart
      supabase_constants.dart
supabase/
  functions/
    match-score/index.ts
    ai-coach/index.ts
    daily-deck/index.ts
    push-notifications/index.ts
  migrations/
    001_initial_schema.sql
    002_rls_policies.sql
    003_seed_data.sql

## Database schema
profiles (id uuid pk, user_id uuid fk auth.users, role text, name text,
  avatar_url text, bio text, skills text[], salary_min int, salary_max int,
  currency text, work_style text, culture_tags text[], experience_years int,
  streak_count int, last_active_date date, passive_mode bool, 
  profile_completion int, created_at timestamptz)

companies (id uuid pk, employer_id uuid fk profiles, name text, 
  logo_url text, size text, culture_tags text[], tech_stack text[],
  description text, website text, created_at timestamptz)

jobs (id uuid pk, company_id uuid fk companies, title text, description text,
  required_skills text[], salary_min int, salary_max int, work_style text,
  experience_years int, is_active bool, expires_at timestamptz)

swipes (id uuid pk, user_id uuid, target_id uuid, target_type text,
  direction text, created_at timestamptz)

matches (id uuid pk, candidate_id uuid, job_id uuid, company_id uuid,
  match_score int, match_reason jsonb, status text, created_at timestamptz)

messages (id uuid pk, match_id uuid, sender_id uuid, content text,
  ai_assisted bool, created_at timestamptz)

## AI architecture
Flutter NEVER calls Claude API directly. Flow:
  Flutter → Supabase Edge Function (Deno/TypeScript) → Claude API → Flutter

Match scoring (match-score Edge Function):
  Skills overlap     40 points
  Salary fit         25 points
  Work style         20 points
  Experience         15 points
  
Claude returns this JSON structure:
{
  "overall_score": 87,
  "dimensions": {
    "skills": { "score": 36, "reason": "string" },
    "salary": { "score": 22, "reason": "string" },
    "work_style": { "score": 18, "reason": "string" },
    "experience": { "score": 11, "reason": "string" }
  },
  "coaching_tip": "string",
  "match_summary": "string (2 sentences max)"
}

## Psychology + retention mechanics (NEVER remove these)
1. Daily deck: exactly 15 cards, refreshed at 8am user local time,
   cards expire after 24 hours (show expiry countdown on card)
2. Match reveal: full-screen Rive animation + HapticFeedback.heavyImpact()
   + show match score animated from 0 to final value over 1.5 seconds
3. Streak: track in profiles.last_active_date, show 🔥 N in bottom nav
4. Daily push at 6pm: "N employers viewed your profile today"
5. Profile completion bar: always visible at top of feed screen
6. Passive mode: toggle in profile, keeps employed users in pool

## Code rules
- All Supabase calls in data/ repositories only, never in widgets
- All state in Riverpod AsyncNotifier providers in domain/ layer
- Every model uses freezed (immutable, copyWith, fromJson, toJson)
- Use flutter_hooks + HookConsumerWidget for all stateful UI
- Screens are thin — only layout and calling providers
- Every loading state shows shimmer skeleton, never a blank screen
- Every error state shows an actionable error widget (retry button)
- Haptic feedback on: swipe right, swipe left, match reveal, button tap
- Dark mode supported from day one (use ThemeData.dark())
- All strings in app_constants.dart, no hardcoded UI text
- Run build_runner after every model change