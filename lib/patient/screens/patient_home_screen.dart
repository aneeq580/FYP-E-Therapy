import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import 'package:fyp_therapy/therapist/widgets/quick_action_tile.dart';
import 'package:fyp_therapy/patient/profile/patient_profile_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../core/constants/styles.dart';

import '../../core/widgets/patient_header.dart';
import '../../core/widgets/patient_app_bar.dart';
import '../../therapist/widgets/therapist_today_session_card.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the same profile controller used in the profile screen so
    // greeting reflects the logged‑in user's name.
    final profileController = Get.put(PatientProfileController(), permanent: true);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: 'Dashboard', showDefaultActions: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Header (keeps existing PatientHeader look)
            Obx(
              () => PatientHeader(
                username: profileController.displayName,
                subtitle: 'Ready for your wellness journey?',
                profileImageUrl:
                    profileController.profileImageUrl.value.isEmpty
                        ? null
                        : profileController.profileImageUrl.value,
                onProfileTap: () {
                  Get.toNamed(AppRoutes.patientProfile);
                },
              ),
            ),

            const SizedBox(height: 10),

            // Compact Quick Actions (keep same style as Therapist, include all patient actions)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                QuickActionTile(
                  icon: AppIcons.bookSession,
                  label: AppStrings.bookSession,
                  iconColor: AppColors.iconBookSession,
                  iconBackgroundColor: AppColors.iconBgBookSession,
                  onTap: () {
                    Get.toNamed(AppRoutes.bookSession);
                  },
                ),

                QuickActionTile(
                  icon: AppIcons.chat,
                  label: AppStrings.chat,
                  iconColor: AppColors.iconChat,
                  iconBackgroundColor: AppColors.iconBgChat,
                  onTap: () {
                    Get.toNamed(AppRoutes.patientChat);
                  },
                ),

                QuickActionTile(
                  icon: AppIcons.therapists,
                  label: AppStrings.therapists,
                  iconColor: AppColors.iconTherapists,
                  iconBackgroundColor: AppColors.iconBgTherapists,
                  onTap: () {
                    Get.toNamed(AppRoutes.therapistList);
                  },
                ),

                QuickActionTile(
                  icon: AppIcons.mySessions,
                  label: AppStrings.mySessions,
                  iconColor: AppColors.iconMySessions,
                  iconBackgroundColor: AppColors.iconBgMySessions,
                  onTap: () {
                    Get.toNamed(AppRoutes.mySessions);
                  },
                ),

                QuickActionTile(
                  icon: AppIcons.moodTracker,
                  label: AppStrings.moodTracker,
                  iconColor: AppColors.iconMoodTracker,
                  iconBackgroundColor: AppColors.iconBgMoodTracker,
                  onTap: () {
                    Get.toNamed(AppRoutes.moodTracker);
                  },
                ),

                QuickActionTile(
                  icon: AppIcons.resources,
                  label: AppStrings.resources,
                  iconColor: AppColors.iconResources,
                  iconBackgroundColor: AppColors.iconBgResources,
                  onTap: () {
                    Get.toNamed(AppRoutes.resources);
                  },
                ),

                QuickActionTile(
                  icon: AppIcons.emergency,
                  label: AppStrings.emergency,
                  iconColor: AppColors.iconEmergency,
                  iconBackgroundColor: AppColors.iconBgEmergency,
                  onTap: () {
                    Get.toNamed(AppRoutes.emergency);
                  },
                ),

                QuickActionTile(
                  icon: AppIcons.settings,
                  label: AppStrings.settings,
                  iconColor: AppColors.iconSettings,
                  iconBackgroundColor: AppColors.iconBgSettings,
                  onTap: () {
                    Get.toNamed(AppRoutes.patientSettings);
                  },
                ),

                // QuickActionTile(
                //   icon: FontAwesomeIcons.rightFromBracket,
                //   label: 'Logout',
                //   iconColor: Colors.red,
                //   iconBackgroundColor: Colors.red.withOpacity(0.2),
                //   onTap: () {
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return AlertDialog(
                //           title: const Text('Logout'),
                //           content: const Text(
                //             'Are you sure you want to logout?',
                //           ),
                //           actions: [
                //             TextButton(
                //               onPressed: () => Navigator.of(context).pop(),
                //               child: const Text('Cancel'),
                //             ),
                //             TextButton(
                //               onPressed: () {
                //                 AppRoutes.navigateClearStackTo(
                //                   context,
                //                   AppRoutes.roleSelection,
                //                 );
                //               },
                //               child: const Text(
                //                 'Logout',
                //                 style: TextStyle(color: Colors.red),
                //               ),
                //             ),
                //           ],
                //         );
                //       },
                //     );
                //   },
                // ),
              ],
            ),

            const SizedBox(height: 20),
            const Text(
              "Today's Sessions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            TherapistTodaySessionCard(
              patientName: "Next Session",
              time: "10:00 AM",
              sessionType: "Video Session",
            ),

            const SizedBox(height: 10),

            TherapistTodaySessionCard(
              patientName: "Follow-up",
              time: "2:30 PM",
              sessionType: "In-Person",
            ),
          ],
        ),
      ),
    );
  }
}
