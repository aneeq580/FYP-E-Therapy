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
import '../../core/widgets/role_based_session_card.dart';
import 'package:fyp_therapy/chat/screens/chat_list_screen.dart';
import 'package:fyp_therapy/chat/screens/chat_screen.dart';
import '../../controllers/appointment_controller.dart';
import '../../controllers/mood_tracker_controller.dart';
import '../../services/mood_service.dart';
import '../../models/resource_model.dart';
import 'resource_list_screen.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(
      PatientProfileController(),
      permanent: true,
    );

    // Ensure MoodService is available before MoodTrackerController
    if (!Get.isRegistered<MoodService>()) {
      Get.put(MoodService(), permanent: true);
    }

    final moodController = Get.put(MoodTrackerController(), permanent: true);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: 'Dashboard', showDefaultActions: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Header
            Obx(
              () => PatientHeader(
                username: profileController.displayName,
                subtitle: 'Ready for your wellness journey?',
                profileImageUrl: profileController.profileImageUrl.value.isEmpty
                    ? null
                    : profileController.profileImageUrl.value,
                onProfileTap: () {
                  Get.toNamed(AppRoutes.patientProfile);
                },
                selectedEmoji: moodController.selectedMood.value,
                onMoodSelected: (emoji) {
                  moodController.setMood(emoji);
                  Get.snackbar(
                    'Mood Logged',
                    'Your mood has been saved successfully! 💙',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.primary.withOpacity(0.8),
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                    duration: const Duration(seconds: 2),
                  );
                  },
                  onQuickBreatheTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResourceListScreen(
                          title: 'Breathing Exercises',
                          category: ResourceCategory.breathing,
                        ),
                      ),
                    );
                  },
                ),
            ),

            const SizedBox(height: 10),

            // Quick Actions Grid
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
                  onTap: () => Get.toNamed(AppRoutes.bookSession),
                ),
                QuickActionTile(
                  icon: AppIcons.therapists,
                  label: AppStrings.therapists,
                  iconColor: AppColors.iconTherapists,
                  iconBackgroundColor: AppColors.iconBgTherapists,
                  onTap: () => Get.toNamed(AppRoutes.therapistList),
                ),
                QuickActionTile(
                  icon: AppIcons.mySessions,
                  label: AppStrings.mySessions,
                  iconColor: AppColors.iconMySessions,
                  iconBackgroundColor: AppColors.iconBgMySessions,
                  onTap: () => Get.toNamed(AppRoutes.mySessions),
                ),
                QuickActionTile(
                  icon: AppIcons.chat,
                  label: AppStrings.chat,
                  iconColor: AppColors.iconChat,
                  iconBackgroundColor: AppColors.iconBgChat,
                  onTap: () {
                    if (!Get.isRegistered<AppointmentController>()) {
                      Get.put(AppointmentController());
                    }
                    Get.to(() => const ChatListScreen(isTherapist: false));
                  },
                ),
                QuickActionTile(
                  icon: AppIcons.moodTracker,
                  label: AppStrings.moodTracker,
                  iconColor: AppColors.iconMoodTracker,
                  iconBackgroundColor: AppColors.iconBgMoodTracker,
                  onTap: () => Get.toNamed(AppRoutes.moodTracker),
                ),
                QuickActionTile(
                  icon: AppIcons.resources,
                  label: AppStrings.resources,
                  iconColor: AppColors.iconResources,
                  iconBackgroundColor: AppColors.iconBgResources,
                  onTap: () => Get.toNamed(AppRoutes.resources),
                ),
                QuickActionTile(
                  icon: AppIcons.emergency,
                  label: AppStrings.emergency,
                  iconColor: AppColors.iconEmergency,
                  iconBackgroundColor: AppColors.iconBgEmergency,
                  onTap: () => Get.toNamed(AppRoutes.emergency),
                ),
                QuickActionTile(
                  icon: AppIcons.settings,
                  label: AppStrings.settings,
                  iconColor: AppColors.iconSettings,
                  iconBackgroundColor: AppColors.iconBgSettings,
                  onTap: () => Get.toNamed(AppRoutes.patientSettings),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Today's Sessions heading
            const Text(
              "Today's Sessions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            Obx(() {
              if (!Get.isRegistered<AppointmentController>()) {
                Get.put(AppointmentController());
              }
              final apptCtrl = Get.find<AppointmentController>();

              // Ongoing + approved/upcoming sessions together
              final sessions = [
                ...apptCtrl.patientOngoingSessions,
                ...apptCtrl.patientAppointments.where(
                  (a) => a.status == 'approved' || a.status == 'upcoming',
                ),
              ];

              // Filter to today only
              final now = DateTime.now();
              final todaysSessions = sessions.where((s) {
                final date = s.date.toDate();
                return date.year == now.year &&
                    date.month == now.month &&
                    date.day == now.day;
              }).toList();

              if (todaysSessions.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.15),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "No sessions scheduled for today.",
                      style: AppTextStyles.bodyTextSecondary,
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: todaysSessions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final session = todaysSessions[index];
                  return RoleBasedSessionCard(
                    appointment: session,
                    role: 'patient',
                    // Button always shows; card disables it when session is not yet active
                    onJoin: () => Get.to(
                      () =>
                          ChatScreen(sessionId: session.id, isTherapist: false),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
