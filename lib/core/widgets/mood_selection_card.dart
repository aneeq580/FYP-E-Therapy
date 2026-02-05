import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';
import 'mood_emoji_button.dart';

/// Reusable widget for mood selection card with emoji row
class MoodSelectionCard extends StatelessWidget {
  final String? selectedMood;
  final Function(String mood) onMoodSelected;

  const MoodSelectionCard({
    super.key,
    this.selectedMood,
    required this.onMoodSelected,
  });

  // Define available moods
  static const List<Map<String, String>> moods = [
    {'emoji': '😢', 'label': 'Sad'},
    {'emoji': '😐', 'label': 'Neutral'},
    {'emoji': '🙂', 'label': 'Good'},
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '😄', 'label': 'Great'},
  ];

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
            'How are you feeling today?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.spacingLarge),

          // Mood emoji row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: moods.map((mood) {
              final moodKey = mood['emoji']!;
              final isSelected = selectedMood == moodKey;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: MoodEmojiButton(
                    emoji: mood['emoji']!,
                    label: mood['label']!,
                    isSelected: isSelected,
                    onTap: () => onMoodSelected(moodKey),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
