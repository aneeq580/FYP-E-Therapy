import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../controllers/patient_activity_controller.dart';
import 'activity_item.dart';

class TherapyActivityCard extends StatelessWidget {
  const TherapyActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller is lazy-loaded but should be available from binding
    final controller = Get.find<PatientActivityController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Row(
          children: [
            Expanded(
              child: Obx(
                () => ActivityItem(
                  icon: FontAwesomeIcons.calendarCheck,
                  title: 'Sessions',
                  value: '${controller.completedSessions.value}',
                  subtitle: 'Completed',
                  color: AppColors.iconMySessions,
                  backgroundColor: AppColors.iconBgMySessions,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spacingMedium),
            Expanded(
              child: Obx(
                () => ActivityItem(
                  icon: FontAwesomeIcons.clock,
                  title: 'Upcoming',
                  value: '${controller.upcomingSessions.value}',
                  subtitle: 'Accepted',
                  color: AppColors.iconBookSession,
                  backgroundColor: AppColors.iconBgBookSession,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spacingMedium),
        Obx(
          () => ActivityItem(
            icon: FontAwesomeIcons.faceSmile,
            title: 'Mood Check-ins',
            value: '${controller.moodCheckIns.value}',
            subtitle: 'Total entries',
            color: AppColors.iconMoodTracker,
            backgroundColor: AppColors.iconBgMoodTracker,
            isFullWidth: true,
          ),
        ),
      ],
    );
  }
}
