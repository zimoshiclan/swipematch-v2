import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF6C63FF);
  static const Color background = Color(0xFF0F0F0F);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color card = Color(0xFF242424);
  static const Color accent = Color(0xFF00E5A0);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color danger = Color(0xFFFF4757);

  // Semantic aliases
  static const Color matchGold = Color(0xFFFFD700);
  static const Color hotBadge = Color(0xFFFF6B35);
  static const Color expiryRed = danger;

  // Swipe actions
  static const Color swipeRight = accent;
  static const Color swipeLeft = danger;
  static const Color superLike = Color(0xFF00C6FF);

  // Overlays
  static const Color overlay = Color(0x99000000);
  static const Color cardGradientStart = Color(0x00000000);
  static const Color cardGradientEnd = Color(0xCC000000);
}
