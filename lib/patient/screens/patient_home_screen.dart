import 'package:flutter/material.dart';
import 'package:fyp_therapy/navigation/app_routes.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/quick_action_tile.dart';
import '../../core/widgets/patient_header.dart';

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
                AppRoutes.navigateTo(context, AppRoutes.patientProfile);
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
                          AppRoutes.navigateTo(
                            context,
                            AppRoutes.therapistList,
                          );
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
                          AppRoutes.navigateTo(
                            context,
                            AppRoutes.patientSettings,
                          );
                        },
                      ),
                      QuickActionTile(
                        icon: Icons.logout,
                        label: 'Logout',
                        iconColor: Colors.red,
                        iconBackgroundColor: Colors.red.withOpacity(0.2),
                        onTap: () {
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Logout'),
                                content: const Text(
                                  'Are you sure you want to logout?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      AppRoutes.navigateClearStackTo(
                                        context,
                                        AppRoutes.roleSelection,
                                      );
                                    },
                                    child: const Text(
                                      'Logout',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
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
