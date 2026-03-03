import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fyp_therapy/core/constants/colors.dart';
import 'package:fyp_therapy/patient/screens/settings_screen.dart';
import 'package:fyp_therapy/therapist/screens/availability_screen.dart';
import 'package:fyp_therapy/therapist/screens/profile_screen.dart';
import '../widgets/therapist_greeting_card.dart';
import '../widgets/therapist_today_session_card.dart';
import '../widgets/quick_action_tile.dart';
import '../widgets/therapist_popup_menu.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import 'package:fyp_therapy/controllers/auth_controller.dart';
import '../../core/widgets/therapist_app_bar.dart';

class TherapistHomeScreen extends StatelessWidget {
  const TherapistHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Get.to(() => const ProfileScreen());
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
                  icon: FontAwesomeIcons.commentDots,
                  label: 'View Chats',
                  iconColor: AppColors.iconChat,
                  iconBackgroundColor: AppColors.iconChat.withOpacity(0.3),
                  onTap: () {
                    Get.toNamed(AppRoutes.therapistChat);
                  },
                ),
                QuickActionTile(
                  icon: FontAwesomeIcons.users,
                  label: 'My Patients',
                  iconColor: AppColors.iconTherapists,
                  iconBackgroundColor: AppColors.iconTherapists.withOpacity(
                    0.3,
                  ),
                ),
                QuickActionTile(
                  icon: FontAwesomeIcons.chartBar,
                  label: 'Reports',
                  iconColor: AppColors.iconMoodTracker,
                  iconBackgroundColor: AppColors.iconMoodTracker.withOpacity(
                    0.3,
                  ),
                  onTap: () {},
                ),
              ],
            ),

            /// 🔹 Today's Sessions Title
            SizedBox(height: 20),
            Text(
              "Today's Sessions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 10),

            /// 🔹 Example Session Cards
            TherapistTodaySessionCard(
              patientName: "Ali Khan",
              time: "10:00 AM",
              sessionType: "Video Session",
            ),

            SizedBox(height: 10),

            TherapistTodaySessionCard(
              patientName: "Sara Ahmed",
              time: "12:30 PM",
              sessionType: "In-Person",
            ),
          ],
        ),
      ),
    );
  }
}
