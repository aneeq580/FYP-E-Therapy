import 'package:flutter/material.dart';

class AppColors {
  // ─── App Theme - Material Purple Palette ──────────────────────────────────
  // App Bar / Header:        #6A1B9A  (purple[900])
  // Main containers/cards:   #8E24AA  (purple[800])
  // FAB / CTA buttons:       #9C27B0  (purple[700])
  // Background tint:         #F8F1FF  (very light purple)

  // Primary Colors
  static const Color primary = Color(
    0xFFB86DE5,
  ); // Main containers, mood cards, highlighted sections
  static const Color primaryDark = Color(
    0xFF6A1B9A,
  ); // Same as appBar — deepest tier
  static const Color primaryLight = Color(
    0xFFD4A5F0,
  ); // Lighter shade of primary
  static const Color fabAccent = Color(0xFF781EAF); // FAB & CTA buttons
  static const Color appBarBackground = Color(0xFF6A1B9A); // Header / App Bar

  // Secondary / Accent Colors
  static const Color secondary = Color(0xFFAB47BC); // Purple[400] — accent
  static const Color secondaryDark = Color(
    0xFF7B1FA2,
  ); // Purple[800] — deep accent
  static const Color secondaryLight = Color(
    0xFFCE93D8,
  ); // Purple[200] — pale accent

  // Text Colors
  static const Color textPrimary = Color(0xFF1A0030); // Very dark purple-black
  static const Color textSecondary = Color(0xFF6D4F7F); // Dusty purple
  static const Color textLight = Color(0xFF9E82A7); // Lavender gray
  static const Color textOnPrimary = Colors.white;

  // Background Colors
  static const Color background = Color(0xFFF8F1FF); // Very light purple tint
  static const Color backgroundLight = Color(
    0xFFF8F1FF,
  ); // Same — whisper purple
  static const Color headerBackground = appBarBackground;

  // Card Colors
  static const Color card = Colors.white;

  // Accent / Semantic Colors
  static const Color accent = secondary;
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color ended = Color(0xFF64748B); // Slate 500

  // Grid Item Colors
  static const Color gridItemBackground = card;
  static const Color gridItemIcon = Color(
    0xFF00ACC1,
  ); // Teal (distinct from theme)
  static const Color gridItemText = textPrimary;

  // Icon Colors
  static const Color iconBookSession = Color(0xFFE53935); // Red
  static const Color iconTherapists = Color(0xFF00BFA5); // Teal
  static const Color iconMySessions = Color(0xFF6F2BBF); // Deep violet
  static const Color iconMoodTracker = Color(0xFFFFC107); // Yellow
  static const Color iconResources = Color(0xFF4B79E5); // Cool blue
  static const Color iconEmergency = Color(0xFFEA4F9F); // Rose
  static const Color iconSettings = Color(0xFF7C6EB9); // Dusty purple
  static const Color iconChat = Color(0xFF00BCD4); // Cyan

  // Icon Background Colors
  static const Color iconBackground = Color(
    0xFFF3E8FB,
  ); // Soft theme background
  static const Color iconBgBookSession = Color(0xFFFFEBEE); // Light red
  static const Color iconBgTherapists = Color(0xFFF3E5F5); // Light lavender
  static const Color iconBgMySessions = Color(0xFFEDE7F6); // Soft violet
  static const Color iconBgMoodTracker = Color(0xFFFFFDE7); // Light yellow
  static const Color iconBgResources = Color(0xFFE9F0FF); // Soft blue
  static const Color iconBgEmergency = Color(0xFFFFE4F0); // Very light pink
  static const Color iconBgSettings = Color(0xFFEDE7F6); // Light dusty purple
  static const Color iconBgChat = Color(0xFFE0F7FA); // Light cyan

  // Therapist-specific Colors (aliases — update here cascades everywhere)
  static const Color therapistPrimary = primary;
  static const Color therapistSecondary = secondary;
  static const Color therapistPrimaryLight = primaryLight;
  static const Color therapistBackground = backgroundLight;
  static const Color therapistSurface = Colors.white;
  static const Color therapistTextPrimary = textPrimary;
  static const Color therapistTextSecondary = textSecondary;
}
