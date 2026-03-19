import 'package:flutter/material.dart';

class AppColors {
  // Patient (Primary) Theme:
  // Primary:   #990F02  (Dark Red)
  // Contrast:  #455A64  (Blue Grey for professional contrast)
  // Background: #FFFFFF / #F5F5F5 (Light grey tint)
  // Text:      #1A1A1B  (Deep Charcoal)
  
  // Therapist Theme:
  // Primary:   #730B02  (Deeper Burgundy Red)
  // Secondary: #5C0901  (Dark Maroon)
  // Background: #FAF9F9 (Soft White tint)
  // Surface:    #FFFFFF

  // Primary Colors
  static const Color primary = Color(0xFF990F02);
  static const Color primaryDark = Color(0xFF7A0C02);
  static const Color primaryLight = Color(0xFFB81203);

  // Secondary / Accent Colors (Contrast Colors)
  static const Color secondary = Color(0xFF455A64);
  static const Color secondaryDark = Color(0xFF263238);
  static const Color secondaryLight = Color(0xFF607D8B);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1B);
  static const Color textSecondary = Color(0xFF6D6D6D);
  static const Color textLight = Color(0xFFB0B0B0);
  static const Color textOnPrimary = Colors.white;

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color headerBackground = primary;

  // Card Colors
  static const Color card = Color(0xFFFFFFFF);

  // Accent / Semantic Colors
  static const Color accent = secondary;
  static const Color success = Color(0xFF2E7D32); // Darker Green for better contrast with red
  static const Color warning = Color(0xFFFFA000);
  static const Color error = Color(0xFFD32F2F);
  static const Color ended = Color(0xFF388E3C);

  // Grid Item Colors
  static const Color gridItemBackground = card;
  static const Color gridItemIcon = primary;
  static const Color gridItemText = textPrimary;

  // Individual Icon Colors (Adjusted for red theme)
  static const Color iconBookSession = Color(0xFFB71C1C); 
  static const Color iconTherapists = Color(0xFF455A64); 
  static const Color iconMySessions = Color(0xFF880E4F); 
  static const Color iconMoodTracker = Color(0xFFCDA434); // Muted Gold contrast
  static const Color iconResources = Color(0xFF2E7D32); 
  static const Color iconEmergency = Color(0xFF990F02); 
  static const Color iconSettings = Color(0xFF546E7A); 
  static const Color iconChat = Color(0xFF37474F); 

  // Light Background Colors for Icons (subtle red/grey tints)
  static const Color iconBgBookSession = Color(0xFFFFEBEE); 
  static const Color iconBgTherapists = Color(0xFFECEFF1); 
  static const Color iconBgMySessions = Color(0xFFFCE4EC); 
  static const Color iconBgMoodTracker = Color(0xFFFFF9C4); 
  static const Color iconBgResources = Color(0xFFE8F5E9); 
  static const Color iconBgEmergency = Color(0xFFFFEBEE); 
  static const Color iconBgSettings = Color(0xFFECEFF1); 
  static const Color iconBgChat = Color(0xFFECEFF1); 

  // Therapist-specific Colors (Deeper shades of red/maroon)
  static const Color therapistPrimary = Color(0xFF730B02);
  static const Color therapistSecondary = Color(0xFF5C0901);
  static const Color therapistPrimaryLight = Color(0xFF990F02);
  static const Color therapistBackground = Color(0xFFFAF9F9);
  static const Color therapistSurface = Colors.white;
  static const Color therapistTextPrimary = Color(0xFF1A1A1B);
  static const Color therapistTextSecondary = Color(0xFF546E7A);
}
