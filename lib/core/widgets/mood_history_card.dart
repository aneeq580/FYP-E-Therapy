import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';

/// Reusable widget for displaying mood history
class MoodHistoryCard extends StatelessWidget {
  const MoodHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Static mood history data (UI only)
    final moodHistory = [
      {'date': 'Today', 'mood': '😊', 'label': 'Happy'},
      {'date': 'Yesterday', 'mood': '🙂', 'label': 'Good'},
      {'date': '2 days ago', 'mood': '😐', 'label': 'Neutral'},
      {'date': '3 days ago', 'mood': '😄', 'label': 'Great'},
      {'date': '4 days ago', 'mood': '😊', 'label': 'Happy'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
      padding: const EdgeInsets.all(AppSizes.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Recent Mood History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.spacingMedium),
          const Divider(height: 1),

          // Mood history list
          ...moodHistory.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSizes.spacingSmall,
              ),
              child: Row(
                children: [
                  Text(entry['mood']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: AppSizes.spacingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry['label']!,
                          style: AppTextStyles.bodyText.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          entry['date']!,
                          style: AppTextStyles.bodyTextSecondary.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
