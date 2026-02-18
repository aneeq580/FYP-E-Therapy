import 'package:flutter/material.dart';
import 'package:fyp_therapy/core/constants/colors.dart';
import '../widgets/therapist_greeting_card.dart';
import '../widgets/therapist_today_session_card.dart';
import '../widgets/quick_action_tile.dart';

class TherapistHomeScreen extends StatelessWidget {
  const TherapistHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: const [
          Icon(Icons.notifications_none),
          SizedBox(width: 16),
          CircleAvatar(radius: 16, backgroundColor: Colors.grey),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Greeting Card
            TherapistGreetingCard(),

            SizedBox(height: 24),

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
                  icon: Icons.calendar_today,
                  label: 'Schedule Session',
                  iconColor: AppColors.iconBookSession,
                  iconBackgroundColor: AppColors.iconBookSession.withOpacity(
                    0.3,
                  ),
                  onTap: () {},
                ),
                QuickActionTile(
                  icon: Icons.chat_bubble_outline,
                  label: 'View Chats',
                  iconColor: AppColors.iconChat,
                  iconBackgroundColor: AppColors.iconChat.withOpacity(0.3),
                  onTap: () {},
                ),
                QuickActionTile(
                  icon: Icons.people_outline,
                  label: 'My Patients',
                  iconColor: AppColors.iconTherapists,
                  iconBackgroundColor: AppColors.iconTherapists.withOpacity(
                    0.3,
                  ),
                ),
                QuickActionTile(
                  icon: Icons.insert_chart_outlined,
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
            Text(
              "Today's Sessions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 16),

            /// 🔹 Example Session Cards
            TherapistTodaySessionCard(
              patientName: "Ali Khan",
              time: "10:00 AM",
              sessionType: "Video Session",
            ),

            SizedBox(height: 12),

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
