import 'package:flutter/material.dart';

class AppColors {
  // Theme provided by user:
  // Primary:  #168E6A  (Deep green)
  // Accent:   #FBB03B  (Warm yellow/orange)
  // Neutral:  #B4B6B7  (Soft grey)
  // Dark:     #292D32  (Very dark grey)

  // Primary Colors
  static const Color primary = Color(0xFF168E6A);
  static const Color primaryDark = Color(0xFF126B52);
  static const Color primaryLight = Color(0xFF2DA07F);

  // Secondary / Accent Colors
  static const Color secondary = Color(0xFFFBB03B);
  static const Color secondaryDark = Color(0xFFCF8C2F);
  static const Color secondaryLight = Color(0xFFFFD59A);

  // Text Colors
  static const Color textPrimary = Color(0xFF292D32);
  static const Color textSecondary = Color(0xFFB4B6B7);
  static const Color textLight = Color(0xFFB4B6B7);
  static const Color textOnPrimary = Colors.white;

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF7F7F8);
  static const Color headerBackground = primary;

  // Card Colors
  static const Color card = Color(0xFFFFFFFF);

  // Accent / Semantic Colors
  static const Color accent = secondary;
  static const Color success = primary;
  static const Color warning = secondary;
  static const Color error = Color(0xFFE74C3C);

  // Grid Item Colors
  static const Color gridItemBackground = card;
  static const Color gridItemIcon = primary;
  static const Color gridItemText = textPrimary;

  // Individual Icon Colors (distinct per quick-action)
  static const Color iconBookSession = Color(0xFF4A90E2); // Blue
  static const Color iconChat = Color(0xFF2ECC71); // Green
  static const Color iconTherapists = Color(0xFFE74C3C); // Red
  static const Color iconMySessions = Color(0xFF9B59B6); // Purple
  static const Color iconMoodTracker = Color(0xFFF39C12); // Orange
  static const Color iconResources = Color(0xFF1ABC9C); // Teal
  static const Color iconEmergency = Color(0xFFE91E63); // Pink
  static const Color iconSettings = Color(0xFF607D8B); // Blue Grey

  // Light Background Colors for Icons (subtle tints)
  static const Color iconBgBookSession = Color(0xFFE3F2FD); // Light Blue
  static const Color iconBgChat = Color(0xFFE8F5E9); // Light Green
  static const Color iconBgTherapists = Color(0xFFFFEBEE); // Light Red
  static const Color iconBgMySessions = Color(0xFFF3E5F5); // Light Purple
  static const Color iconBgMoodTracker = Color(0xFFFFF3E0); // Light Orange
  static const Color iconBgResources = Color(0xFFE0F2F1); // Light Teal
  static const Color iconBgEmergency = Color(0xFFFCE4EC); // Light Pink
  static const Color iconBgSettings = Color(0xFFECEFF1); // Light Blue Grey
}
