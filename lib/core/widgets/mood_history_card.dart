import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';
import '../../models/mood_entry.dart';

/// Reusable widget for displaying mood history with insights.
class MoodHistoryCard extends StatelessWidget {
  final List<MoodEntry> history;
  final String progressSummary;
  final String suggestion;

  const MoodHistoryCard({
    super.key,
    required this.history,
    required this.progressSummary,
    required this.suggestion,
  });

  String _formatDate(MoodEntry entry) {
    final dt = entry.date.toDate();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDay = DateTime(dt.year, dt.month, dt.day);

    final difference = today.difference(entryDay).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '$difference days ago';
    return DateFormat('dd MMM').format(dt);
  }

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: AppSizes.spacingSmall),
          if (progressSummary.isNotEmpty) ...[
            Text(
              progressSummary,
              style: AppTextStyles.bodyTextSecondary,
            ),
            const SizedBox(height: AppSizes.spacingSmall),
          ],
          if (suggestion.isNotEmpty) ...[
            Text(
              suggestion,
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.spacingMedium),
          ],
          const Divider(height: 1),
          if (history.isEmpty) ...[
            const SizedBox(height: AppSizes.spacingMedium),
            Text(
              'No mood entries yet. Start by selecting how you feel today.',
              style: AppTextStyles.bodyTextSecondary,
            ),
          ] else ...[
            ...history.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.spacingSmall,
                ),
                child: Row(
                  children: [
                    Text(
                      entry.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: AppSizes.spacingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.label,
                            style: AppTextStyles.bodyText.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _formatDate(entry),
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
        ],
      ),
    );
  }
}

