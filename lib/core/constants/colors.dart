import 'package:flutter/material.dart';

class AppColors {
  // Patient Theme:
  // Primary:   #23BBB7  (Turquoise)
  // Secondary: #23627C  (Deep Blue)
  // Background: #FFFFFF / #F0FAFD (Light Cyan tint)
  // Text:      #1A2D3A  (Dark navy-grey for readability)

  // Primary Colors
  static const Color primary = Color(0xFF23BBB7);
  static const Color primaryDark = Color(0xFF1A8E8B);
  static const Color primaryLight = Color(0xFF5DD0CD);

  // Secondary / Accent Colors
  static const Color secondary = Color(0xFF23627C);
  static const Color secondaryDark = Color(0xFF194A5D);
  static const Color secondaryLight = Color(0xFF3A8BA8);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A2D3A);
  static const Color textSecondary = Color(0xFF8BA4AE);
  static const Color textLight = Color(0xFFB0C4CC);
  static const Color textOnPrimary = Colors.white;

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF0FAFD);
  static const Color headerBackground = primary;

  // Card Colors
  static const Color card = Color(0xFFFFFFFF);

  // Accent / Semantic Colors
  static const Color accent = secondary;
  static const Color success = Color(0xFF23BBB7);
  static const Color warning = Color(0xFFF0A500);
  static const Color error = Color(0xFFE74C3C);
  static const Color ended = Color(0xFF4CAF50);

  // Grid Item Colors
  static const Color gridItemBackground = card;
  static const Color gridItemIcon = primary;
  static const Color gridItemText = textPrimary;

  // Individual Icon Colors (distinct per quick-action)
  static const Color iconBookSession = Color(0xFF4A90E2); // Blue
  static const Color iconTherapists = Color(0xFFE74C3C); // Red
  static const Color iconMySessions = Color(0xFF9B59B6); // Purple
  static const Color iconMoodTracker = Color(0xFFF39C12); // Orange
  static const Color iconResources = Color(0xFF1ABC9C); // Teal
  static const Color iconEmergency = Color(0xFFE91E63); // Pink
  static const Color iconSettings = Color(0xFF607D8B); // Blue Grey
  static const Color iconChat = Color(0xFF00BCD4); // Cyan

  // Light Background Colors for Icons (subtle tints)
  static const Color iconBgBookSession = Color(0xFFE3F2FD); // Light Blue
  static const Color iconBgTherapists = Color(0xFFFFEBEE); // Light Red
  static const Color iconBgMySessions = Color(0xFFF3E5F5); // Light Purple
  static const Color iconBgMoodTracker = Color(0xFFFFF3E0); // Light Orange
  static const Color iconBgResources = Color(0xFFE0F2F1); // Light Teal
  static const Color iconBgEmergency = Color(0xFFFCE4EC); // Light Pink
  static const Color iconBgSettings = Color(0xFFECEFF1); // Light Blue Grey
  static const Color iconBgChat = Color(0xFFE0F7FA); // Light Cyan
}
