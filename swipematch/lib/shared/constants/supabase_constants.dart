class SupabaseConstants {
  SupabaseConstants._();

  // Override at build time: flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://hykvvafcgizrcubiqpdw.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh5a3Z2YWZjZ2l6cmN1YmlxcGR3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk0OTY1OTIsImV4cCI6MjA5NTA3MjU5Mn0.ofPzlvwQ5p_0_GeIM7bDJr_Q5domY1poJ3JDHwKcWB8',
  );

  // Deep link scheme for auth callbacks
  // Platform config required — see android/app/src/main/AndroidManifest.xml
  static const String authRedirectUrl = 'com.swipematch://login-callback';

  // Table names
  static const String profiles = 'profiles';
  static const String companies = 'companies';
  static const String jobs = 'jobs';
  static const String swipes = 'swipes';
  static const String matches = 'matches';
  static const String messages = 'messages';
  static const String salaryReports = 'salary_reports';
  static const String interviewIntel = 'interview_intel';
  static const String skillsScores = 'skills_scores';
  static const String posts = 'posts';
  static const String postLikes = 'post_likes';
  static const String postComments = 'post_comments';
  static const String commentLikes = 'comment_likes';
  static const String postBookmarks = 'post_bookmarks';
  static const String connections = 'connections';
  static const String appNotifications = 'app_notifications';

  // Realtime channels
  static const String messagesChannel = 'messages';
  static const String matchesChannel = 'matches';

  // Edge function names
  static const String fnMatchScore = 'match-score';
  static const String fnAiCoach = 'ai-coach';
  static const String fnDailyDeck = 'daily-deck';
  static const String fnPushNotifications = 'push-notifications';
  static const String fnGhostSweep = 'ghost-sweep';
  static const String fnPitchTranscribe = 'pitch-transcribe';

  // Storage buckets
  static const String avatarsBucket = 'avatars';
  static const String logosBucket = 'logos';
  static const String pitchesBucket = 'pitches';
  static const String postMediaBucket = 'post-media';
}
