import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'colors.dart';

class AppTextStyles {
  // Font Family
  static const String fontFamily = 'Roboto';

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 24.0;
  static const double fontSizeXXXLarge = 28.0;

  // Header Styles
  static const TextStyle headerTitle = TextStyle(
    fontSize: fontSizeXXLarge,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnPrimary,
    fontFamily: fontFamily,
  );

  static const TextStyle headerSubtitle = TextStyle(
    fontSize: fontSizeLarge,
    fontWeight: FontWeight.normal,
    color: AppColors.textOnPrimary,
    fontFamily: fontFamily,
  );

  // Grid Item Styles
  static const TextStyle gridItemText = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: FontWeight.w500,
    color: AppColors.gridItemText,
    fontFamily: fontFamily,
  );

  // General Text Styles
  static const TextStyle bodyText = TextStyle(
    fontSize: fontSizeMedium,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );

  static const TextStyle bodyTextSecondary = TextStyle(
    fontSize: fontSizeMedium,
    color: AppColors.textSecondary,
    fontFamily: fontFamily,
  );
}

class AppSizes {
  // Grid Item
  static const double gridItemHeight = 100.0;
  static const double gridItemIconSize = 26.0;

  // Header
  static const double headerBorderRadius = 25.0;
  static const double headerPadding = 20.0;
  static const double profileImageSize = 50.0;

  // Spacing
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
}

class AppIcons {
  // Grid Item Icons (Beautiful Font Awesome Icons)
  static const IconData bookSession = FontAwesomeIcons.calendarCheck;
  static const IconData chat = FontAwesomeIcons.comments;
  static const IconData therapists = FontAwesomeIcons.userDoctor;
  static const IconData mySessions = FontAwesomeIcons.calendarDays;
  static const IconData moodTracker = FontAwesomeIcons.faceSmile;
  static const IconData resources = FontAwesomeIcons.bookOpen;
  static const IconData emergency = FontAwesomeIcons.circleExclamation;
  static const IconData settings = FontAwesomeIcons.gear;

  // Header Icons
  static const IconData profile = FontAwesomeIcons.userCircle;
}
