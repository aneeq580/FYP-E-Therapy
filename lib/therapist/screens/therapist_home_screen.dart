import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fyp_therapy/core/constants/colors.dart';
import 'package:fyp_therapy/patient/screens/settings_screen.dart';
import 'package:fyp_therapy/therapist/screens/availability_screen.dart';
import '../widgets/therapist_greeting_card.dart';
import '../widgets/therapist_today_session_card.dart';
import '../widgets/quick_action_tile.dart';
import '../widgets/therapist_popup_menu.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import 'package:fyp_therapy/core/constants/strings.dart';
import 'package:fyp_therapy/core/constants/styles.dart';
import 'package:fyp_therapy/controllers/auth_controller.dart';
import '../../core/widgets/therapist_app_bar.dart';
import 'package:fyp_therapy/chat/screens/chat_list_screen.dart';
import 'package:fyp_therapy/chat/screens/chat_screen.dart';
import '../../controllers/appointment_controller.dart';

class TherapistHomeScreen extends StatelessWidget {
  const TherapistHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.therapistBackground,
      appBar: TherapistAppBar(
        title: "Dashboard",
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.bell, color: Colors.white),
            onPressed: () {
              // notifications screen
            },
          ),

          TherapistPopupMenu(
            onSelected: (value) {
              if (value == 'availability') {
                Get.to(() => const AvailabilityScreen());
              } else if (value == 'profile') {
                Get.toNamed(AppRoutes.therapistProfile);
              } else if (value == 'settings') {
                Get.to(() => const SettingsScreen());
              } else if (value == 'logout') {
                final authController = Get.find<AuthController>();
                authController.handleLogout();
              }
            },
          ),

          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Greeting Card
            TherapistGreetingCard(),

            SizedBox(height: 22),

            /// 🔹 Quick Actions (Reused)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                QuickActionTile(
                  icon: FontAwesomeIcons.clipboardList,
                  label: 'Appointment Requests',
                  iconColor: AppColors.iconBookSession,
                  iconBackgroundColor: AppColors.iconBookSession.withOpacity(
                    0.3,
                  ),
                  onTap: () {
                    Get.toNamed(AppRoutes.appointmentRequests);
                  },
                ),

                QuickActionTile(
                  icon: FontAwesomeIcons.users,
                  label: 'My Patients',
                  iconColor: AppColors.iconTherapists,
                  iconBackgroundColor: AppColors.iconTherapists.withOpacity(
                    0.3,
                  ),
                  onTap: () {
                    Get.toNamed(AppRoutes.therapistPatients);
                  },
                ),
                QuickActionTile(
                  icon: FontAwesomeIcons.comments,
                  label: AppStrings.chat,
                  iconColor: AppColors.iconChat,
                  iconBackgroundColor: AppColors.iconBgChat,
                  onTap: () {
                    if (!Get.isRegistered<AppointmentController>()) {
                      Get.put(AppointmentController());
                    }
                    Get.to(() => ChatListScreen(isTherapist: true));
                  },
                ),
                QuickActionTile(
                  icon: FontAwesomeIcons.chartBar,
                  label: 'Reports',
                  iconColor: AppColors.iconMoodTracker,
                  iconBackgroundColor: AppColors.iconMoodTracker.withOpacity(
                    0.3,
                  ),
                  onTap: () {
                    Get.toNamed(AppRoutes.therapistReports);
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),
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

              // Combine active and upcoming sessions for the therapist
              final sessions = [
                ...apptCtrl.therapistActiveSessions,
                ...apptCtrl.therapistUpcomingAppointments,
              ];

              // Filter to show only sessions scheduled for today
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
                    border: Border.all(color: Colors.grey.shade200),
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
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final session = todaysSessions[index];
                  // Format time (e.g., "10:00 AM")
                  final timeString =
                      "${session.date.toDate().hour > 12 ? session.date.toDate().hour - 12 : session.date.toDate().hour}:${session.date.toDate().minute.toString().padLeft(2, '0')} ${session.date.toDate().hour >= 12 ? 'PM' : 'AM'}";

                  return TherapistTodaySessionCard(
                    appointment: session,
                    time: timeString,
                    sessionType: "${session.duration} min Session",
                    onStart: () async {
                      await apptCtrl.startSession(session.id);
                      Get.to(
                        () => ChatScreen(
                          sessionId: session.id,
                          isTherapist: true,
                        ),
                      );
                    },
                    onChat: () {
                      Get.to(
                        () => ChatScreen(
                          sessionId: session.id,
                          isTherapist: true,
                        ),
                      );
                    },
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
