import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// A soft card widget for daily mood check-in
/// Displays title, subtitle, mood emojis, and optional reminder text
class CheckInCard extends StatelessWidget {
  /// Title of the check-in card
  final String title;

  /// Subtitle/question text
  final String subtitle;

  /// List of mood emojis to display
  final List<String> moodEmojis;

  /// Optional reminder text (e.g., "Your next session is tomorrow")
  final String? reminderText;

  const CheckInCard({
    super.key,
    this.title = "Today's Check-in",
    this.subtitle = "How are you feeling today?",
    this.moodEmojis = const ['🙂', '😐', '😔', '😄', '😌'],
    this.reminderText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        // Soft shadow for depth
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 20),

          // Mood Emojis Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: moodEmojis.map((emoji) {
              return GestureDetector(
                onTap: () {
                  // Placeholder for future mood selection logic
                  // This is UI-only, so no state management here
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 32)),
                ),
              );
            }).toList(),
          ),

          // Optional Reminder Text
          if (reminderText != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      reminderText!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
