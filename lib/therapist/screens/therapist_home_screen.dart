import 'package:flutter/material.dart';
import 'package:fyp_therapy/navigation/app_routes.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/quick_action_tile.dart';

class TherapistHomeScreen extends StatelessWidget {
  const TherapistHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String therapistName = 'Dr. Smith';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.spacingMedium),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome back',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            therapistName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Manage your clients and appointments',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          AppRoutes.navigateTo(
                            context,
                            AppRoutes.therapistProfile,
                          );
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: const NetworkImage(
                            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                      // Appointment Requests
                      QuickActionTile(
                        icon: Icons.calendar_today,
                        label: 'Appointment\nRequests',
                        iconColor: AppColors.iconBookSession,
                        iconBackgroundColor: AppColors.iconBgBookSession,
                        onTap: () {
                          AppRoutes.navigateTo(
                            context,
                            AppRoutes.appointmentRequests,
                          );
                        },
                      ),

                      // Clients/Chat
                      QuickActionTile(
                        icon: Icons.supervised_user_circle,
                        label: 'My Clients',
                        iconColor: AppColors.iconChat,
                        iconBackgroundColor: AppColors.iconBgChat,
                        onTap: () {
                          AppRoutes.navigateTo(
                            context,
                            AppRoutes.therapistChat,
                          );
                        },
                      ),

                      // Messages
                      QuickActionTile(
                        icon: Icons.mail_outline,
                        label: 'Messages',
                        iconColor: AppColors.iconTherapists,
                        iconBackgroundColor: AppColors.iconBgTherapists,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Messages feature coming soon'),
                            ),
                          );
                        },
                      ),

                      // Reports/Analytics
                      QuickActionTile(
                        icon: Icons.bar_chart,
                        label: 'Reports',
                        iconColor: AppColors.iconMySessions,
                        iconBackgroundColor: AppColors.iconBgMySessions,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Reports feature coming soon'),
                            ),
                          );
                        },
                      ),

                      // Availability
                      QuickActionTile(
                        icon: Icons.schedule,
                        label: 'Availability',
                        iconColor: AppColors.iconMoodTracker,
                        iconBackgroundColor: AppColors.iconBgMoodTracker,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Availability feature coming soon'),
                            ),
                          );
                        },
                      ),

                      // Support/Help
                      QuickActionTile(
                        icon: Icons.help_outline,
                        label: 'Help & Support',
                        iconColor: AppColors.iconResources,
                        iconBackgroundColor: AppColors.iconBgResources,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Help feature coming soon'),
                            ),
                          );
                        },
                      ),

                      // Settings
                      QuickActionTile(
                        icon: Icons.settings,
                        label: 'Settings',
                        iconColor: AppColors.iconSettings,
                        iconBackgroundColor: AppColors.iconBgSettings,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Settings feature coming soon'),
                            ),
                          );
                        },
                      ),

                      // Logout
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
