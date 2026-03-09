import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';

/// A single activity statistic tile used inside [TherapyActivityCard].
///
/// Displays an [icon] with a coloured background, a large [value] string,
/// a [title], and an optional [subtitle].
class ActivityItem extends StatelessWidget {
  const ActivityItem({
    super.key,
    required this.icon,
    required this.value,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.iconBackground,
    this.isFullWidth = false,
  });

  final IconData icon;
  final String value;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color iconBackground;

  /// When true the card stretches to full available width (used for the
  /// mood check-in tile that sits below the two half-width cards).
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(AppSizes.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon badge
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: FaIcon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(height: AppSizes.spacingSmall),
          // Numeric value
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          // Title
          Text(
            title,
            style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w500),
          ),
          // Subtitle
          Text(
            subtitle,
            style: AppTextStyles.bodyTextSecondary.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
