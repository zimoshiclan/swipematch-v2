import 'package:flutter/services.dart';

class AppHaptics {
  AppHaptics._();

  static Future<void> swipeRight() => HapticFeedback.mediumImpact();
  static Future<void> swipeLeft() => HapticFeedback.lightImpact();
  static Future<void> superLike() => HapticFeedback.heavyImpact();
  static Future<void> matchReveal() => HapticFeedback.heavyImpact();
  static Future<void> buttonTap() => HapticFeedback.selectionClick();
  static Future<void> error() => HapticFeedback.vibrate();
}
