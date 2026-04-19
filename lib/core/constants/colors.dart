import 'package:flutter/material.dart';

class AppColors {
  // Patient (Primary) Theme - Inspired by Onboarding Page 1 & 3 (Indigo/Purple):
  // Primary:   #6366F1  (Indigo)
  // Contrast:  #4F46E5  (Darker Indigo)
  // Background: #FFFFFF / #F8FAFC (Slate tint)
  // Text:      #0F172A  (Deep Slate)

  // Therapist Theme - Inspired by Onboarding Page 2 (Mint/Emerald):
  // Primary:   #059669  (Emerald)
  // Secondary: #047857  (Dark Emerald)
  // Background: #F9FAFB (Soft Gray-White)
  // Surface:    #FFFFFF

  // Primary Colors (Patient)
  static const Color primary = Color(0xFF6366F1); // Indigo 500
  static const Color primaryDark = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryLight = Color(0xFF818CF8); // Indigo 400

  // Secondary / Accent Colors (Purple tones)
  static const Color secondary = Color(0xFF8B5CF6); // Violet 500
  static const Color secondaryDark = Color(0xFF7C3AED); // Violet 600
  static const Color secondaryLight = Color(0xFFC084FC); // Purple 400

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textLight = Color(0xFF94A3B8); // Slate 400
  static const Color textOnPrimary = Colors.white;

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate 50
  static const Color headerBackground = primary;

  // Card Colors
  static const Color card = Color(0xFFFFFFFF);

  // Accent / Semantic Colors
  static const Color accent = secondary;
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color ended = Color(0xFF64748B); // Slate 500

  // Grid Item Colors
  static const Color gridItemBackground = card;
  static const Color gridItemIcon = primary;
  static const Color gridItemText = textPrimary;

  // Individual Icon Colors (Distinct vibrant palette)
  static const Color iconBookSession = Color(0xFF6366F1); // Indigo
  static const Color iconTherapists = Color(0xFF8B5CF6); // Violet
  static const Color iconMySessions = Color(0xFF10B981); // Emerald
  static const Color iconMoodTracker = Color(0xFFF59E0B); // Amber
  static const Color iconResources = Color(0xFF0EA5E9); // Sky Blue
  static const Color iconEmergency = Color(0xFFF43F5E); // Rose
  static const Color iconSettings = Color(0xFF64748B); // Slate
  static const Color iconChat = Color(0xFFEC4899); // Pink

  // Light Background Colors for Icons
  static const Color iconBgBookSession = Color(0xFFE0E7FF); // Light Indigo
  static const Color iconBgTherapists = Color(0xFFEDE9FE); // Light Violet
  static const Color iconBgMySessions = Color(0xFFD1FAE5); // Light Emerald
  static const Color iconBgMoodTracker = Color(0xFFFEF3C7); // Light Amber
  static const Color iconBgResources = Color(0xFFE0F2FE); // Light Sky Blue
  static const Color iconBgEmergency = Color(0xFFFFE4E6); // Light Rose
  static const Color iconBgSettings = Color(0xFFF1F5F9); // Light Slate
  static const Color iconBgChat = Color(0xFFFCE7F3); // Light Pink

  // Therapist-specific Colors (Mint/Emerald Theme)
  static const Color therapistPrimary = Color(0xFF059669); // Emerald 600
  static const Color therapistSecondary = Color(0xFF047857); // Emerald 700
  static const Color therapistPrimaryLight = Color(0xFF34D399); // Emerald 400 (From Onboarding)
  static const Color therapistBackground = Color(0xFFF9FAFB);
  static const Color therapistSurface = Colors.white;
  static const Color therapistTextPrimary = Color(0xFF0F172A);
  static const Color therapistTextSecondary = Color(0xFF475569);
}
