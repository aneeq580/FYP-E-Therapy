import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controllers/patient_activity_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import 'activity_item.dart';

/// Displays real-time therapy activity statistics for the logged-in patient.
///
/// Reads from [PatientActivityController] and rebuilds each counter
/// independently via [Obx] so only the changed value widget re-renders.
///
/// Layout:
///   ┌──────────────────────────────┐
///   │  Sessions         Upcoming   │  ← two half-width cards in a row
///   │  Completed        (accepted) │
///   ├──────────────────────────────┤
///   │  Mood Check-ins (full width) │
///   └──────────────────────────────┘
class TherapyActivityCard extends StatelessWidget {
  const TherapyActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PatientActivityController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section title ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(
              left: AppSizes.spacingMedium,
              bottom: AppSizes.spacingMedium,
            ),
            child: Text(
              'Therapy Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // ── Sessions + Upcoming row ───────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Obx(
                  () => ActivityItem(
                    icon: FontAwesomeIcons.calendarCheck,
                    value: controller.completedSessions.value.toString(),
                    title: 'Sessions',
                    subtitle: 'Completed',
                    iconColor: AppColors.iconMySessions,
                    iconBackground: AppColors.iconBgMySessions,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spacingMedium),
              Expanded(
                child: Obx(
                  () => ActivityItem(
                    icon: FontAwesomeIcons.clock,
                    value: controller.upcomingSessions.value.toString(),
                    title: 'Upcoming',
                    subtitle: 'Accepted',
                    iconColor: AppColors.iconBookSession,
                    iconBackground: AppColors.iconBgBookSession,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spacingMedium),

          // ── Mood check-ins (full width) ───────────────────────────────────
          Obx(
            () => ActivityItem(
              icon: FontAwesomeIcons.faceSmile,
              value: controller.moodCheckIns.value.toString(),
              title: 'Mood Check-ins',
              subtitle: 'Total entries',
              iconColor: AppColors.iconMoodTracker,
              iconBackground: AppColors.iconBgMoodTracker,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }
}
