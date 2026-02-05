import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/mood_selection_card.dart';
import '../../core/widgets/mood_history_card.dart';

/// Mood Tracker Screen - Main screen for tracking daily moods
class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  String? selectedMood;

  void _handleMoodSelection(String mood) {
    setState(() {
      selectedMood = mood;
    });
    // TODO: Save mood to backend/local storage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppSizes.spacingLarge),

            // Mood Selection Card
            MoodSelectionCard(
              selectedMood: selectedMood,
              onMoodSelected: _handleMoodSelection,
            ),

            const SizedBox(height: AppSizes.spacingLarge),

            // Mood History Card
            const MoodHistoryCard(),

            const SizedBox(height: AppSizes.spacingLarge),
          ],
        ),
      ),
    );
  }
}
