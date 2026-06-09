class NotificationConstants {
  NotificationConstants._();

  // FCM topics
  static const String topicAll = 'all_users';

  // Notification channels (Android)
  static const String channelMatches = 'matches';
  static const String channelDeck = 'deck';
  static const String channelEngagement = 'engagement';

  // Local notification IDs
  static const int idDeckReady = 1;
  static const int idStreakReminder = 2;
  static const int idExpiryWarning = 3;
  static const int idWeeklyReview = 4;
}
