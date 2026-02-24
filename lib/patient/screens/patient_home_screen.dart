import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fyp_therapy/navigation/app_routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fyp_therapy/therapist/widgets/quick_action_tile.dart';
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
    const String username = 'Aneeq';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: 'Dashboard', showDefaultActions: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Header (keeps existing PatientHeader look)
            PatientHeader(
              username: username,
              subtitle: 'Ready for your wellness journey?',
              profileImageUrl:
                  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face',
              onProfileTap: () {
                AppRoutes.navigateTo(context, AppRoutes.patientProfile);
              },
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
                    AppRoutes.navigateTo(context, AppRoutes.bookSession);
                  },
                ),

                QuickActionTile(
                  icon: AppIcons.chat,
                  label: AppStrings.chat,
                  iconColor: AppColors.iconChat,
                  iconBackgroundColor: AppColors.iconBgChat,
                  onTap: () {
                    AppRoutes.navigateTo(context, AppRoutes.patientChat);
                  },
                ),

                QuickActionTile(
                  icon: AppIcons.therapists,
                  label: AppStrings.therapists,
                  iconColor: AppColors.iconTherapists,
                  iconBackgroundColor: AppColors.iconBgTherapists,
                  onTap: () {
                    AppRoutes.navigateTo(context, AppRoutes.therapistList);
                  },
                ),

                QuickActionTile(
                  icon: AppIcons.mySessions,
                  label: AppStrings.mySessions,
                  iconColor: AppColors.iconMySessions,
                  iconBackgroundColor: AppColors.iconBgMySessions,
                  onTap: () {
                    AppRoutes.navigateTo(context, AppRoutes.mySessions);
                  },
                ),

                QuickActionTile(
                  icon: AppIcons.moodTracker,
                  label: AppStrings.moodTracker,
                  iconColor: AppColors.iconMoodTracker,
                  iconBackgroundColor: AppColors.iconBgMoodTracker,
                  onTap: () {
                    AppRoutes.navigateTo(context, AppRoutes.moodTracker);
                  },
                ),

                QuickActionTile(
                  icon: AppIcons.resources,
                  label: AppStrings.resources,
                  iconColor: AppColors.iconResources,
                  iconBackgroundColor: AppColors.iconBgResources,
                  onTap: () {
                    AppRoutes.navigateTo(context, AppRoutes.resources);
                  },
                ),

                QuickActionTile(
                  icon: AppIcons.emergency,
                  label: AppStrings.emergency,
                  iconColor: AppColors.iconEmergency,
                  iconBackgroundColor: AppColors.iconBgEmergency,
                  onTap: () {
                    AppRoutes.navigateTo(context, AppRoutes.emergency);
                  },
                ),

                QuickActionTile(
                  icon: AppIcons.settings,
                  label: AppStrings.settings,
                  iconColor: AppColors.iconSettings,
                  iconBackgroundColor: AppColors.iconBgSettings,
                  onTap: () {
                    AppRoutes.navigateTo(context, AppRoutes.patientSettings);
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
