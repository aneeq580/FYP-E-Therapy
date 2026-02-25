import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/mood_tracker_controller.dart';
import '../../core/widgets/patient_app_bar.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/mood_selection_card.dart';
import '../../core/widgets/mood_history_card.dart';

/// Mood Tracker Screen - Main screen for tracking daily moods
class MoodTrackerScreen extends GetView<MoodTrackerController> {
  const MoodTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PatientAppBar(title: 'Mood Tracker'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppSizes.spacingLarge),

            // Mood Selection Card
            Obx(
              () => MoodSelectionCard(
                selectedMood: controller.selectedMood.value,
                onMoodSelected: controller.setMood,
              ),
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
