import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/quick_action_tile.dart';
import '../../core/widgets/patient_header.dart';
import 'book_session_screen.dart';
import 'chat_screen.dart';
import 'therapist_list_screen.dart';
import 'my_sessions_screen.dart';
import 'mood_tracker_screen.dart';
import 'resources_screen.dart';
import 'emergency_screen.dart';
import 'settings_screen.dart';
import '../profile/patient_profile_screen.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String username = 'Aneeq';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            PatientHeader(
              username: username,
              subtitle: 'Ready for your wellness journey?',
              profileImageUrl:
                  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face',
              onProfileTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PatientProfileScreen(),
                                      ),
                                    );
                                  },
            ),

            // Heading Section
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spacingMedium,
                AppSizes.spacingLarge,
                AppSizes.spacingMedium,
                AppSizes.spacingSmall,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: AppTextStyles.bodyText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingSmall),
                  Container(
                    height: 6,
                    width: 96,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),

            // Grid Section with subtle background for contrast
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.spacingMedium,
                    AppSizes.spacingMedium,
                  AppSizes.spacingMedium,
                  AppSizes.spacingMedium,
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSizes.spacingMedium,
                  crossAxisSpacing: AppSizes.spacingMedium,
                    childAspectRatio: 1.05,
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
                    QuickActionTile(
                      icon: AppIcons.moodTracker,
                      label: AppStrings.moodTracker,
                      iconColor: AppColors.iconMoodTracker,
                      iconBackgroundColor: AppColors.iconBgMoodTracker,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MoodTrackerScreen(),
                            ),
                          );
                        },
                    ),
                    QuickActionTile(
                      icon: AppIcons.resources,
                      label: AppStrings.resources,
                      iconColor: AppColors.iconResources,
                      iconBackgroundColor: AppColors.iconBgResources,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResourcesScreen(),
                            ),
                          );
                        },
                    ),
                    QuickActionTile(
                      icon: AppIcons.emergency,
                      label: AppStrings.emergency,
                      iconColor: AppColors.iconEmergency,
                      iconBackgroundColor: AppColors.iconBgEmergency,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EmergencyScreen(),
                            ),
                          );
                        },
                    ),
                    QuickActionTile(
                      icon: AppIcons.settings,
                      label: AppStrings.settings,
                      iconColor: AppColors.iconSettings,
                      iconBackgroundColor: AppColors.iconBgSettings,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                    ),
                  ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
