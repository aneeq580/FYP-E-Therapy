import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/quick_action_tile.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/check_in_card.dart';
import 'book_session_screen.dart';
import 'chat_screen.dart';
import 'therapist_list_screen.dart';
import 'my_sessions_screen.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Simple App Header
            const AppHeader(appTitle: 'MindCare'),

            // Vertical spacing
            const SizedBox(height: 5),

            // Today's Check-in Card
            const CheckInCard(
              title: "Today's Check-in",
              subtitle: "How are you feeling today?",
              moodEmojis: ['🙂', '😐', '😔', '😄', '😌'],
              reminderText: "Your next session is tomorrow",
            ),

            // Heading Section
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spacingMedium,
                AppSizes.spacingMedium,
                AppSizes.spacingMedium,
                AppSizes.spacingSmall,
              ),
              child: Row(
                children: [
                  Text(
                    'Quick Actions',
                    style: AppTextStyles.bodyText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Grid Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.spacingMedium,
                  0,
                  AppSizes.spacingMedium,
                  AppSizes.spacingMedium,
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSizes.spacingMedium,
                  crossAxisSpacing: AppSizes.spacingMedium,
                  childAspectRatio: 1.3,
                  children: [
                    QuickActionTile(
                      icon: AppIcons.bookSession,
                      label: AppStrings.bookSession,
                      iconColor: AppColors.iconBookSession,
                      iconBackgroundColor: AppColors.iconBgBookSession,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookSessionScreen(),
                          ),
                        );
                      },
                    ),
                    QuickActionTile(
                      icon: AppIcons.chat,
                      label: AppStrings.chat,
                      iconColor: AppColors.iconChat,
                      iconBackgroundColor: AppColors.iconBgChat,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatScreen(),
                          ),
                        );
                      },
                    ),
                    QuickActionTile(
                      icon: AppIcons.therapists,
                      label: AppStrings.therapists,
                      iconColor: AppColors.iconTherapists,
                      iconBackgroundColor: AppColors.iconBgTherapists,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TherapistListScreen(),
                          ),
                        );
                      },
                    ),
                    QuickActionTile(
                      icon: AppIcons.mySessions,
                      label: AppStrings.mySessions,
                      iconColor: AppColors.iconMySessions,
                      iconBackgroundColor: AppColors.iconBgMySessions,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MySessionsScreen(),
                          ),
                        );
                      },
                    ),
                    const QuickActionTile(
                      icon: AppIcons.moodTracker,
                      label: AppStrings.moodTracker,
                      iconColor: AppColors.iconMoodTracker,
                      iconBackgroundColor: AppColors.iconBgMoodTracker,
                    ),
                    const QuickActionTile(
                      icon: AppIcons.resources,
                      label: AppStrings.resources,
                      iconColor: AppColors.iconResources,
                      iconBackgroundColor: AppColors.iconBgResources,
                    ),
                    const QuickActionTile(
                      icon: AppIcons.emergency,
                      label: AppStrings.emergency,
                      iconColor: AppColors.iconEmergency,
                      iconBackgroundColor: AppColors.iconBgEmergency,
                    ),
                    const QuickActionTile(
                      icon: AppIcons.settings,
                      label: AppStrings.settings,
                      iconColor: AppColors.iconSettings,
                      iconBackgroundColor: AppColors.iconBgSettings,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
