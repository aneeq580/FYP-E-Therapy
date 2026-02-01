import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// A simple, clean header widget for the app
/// Displays app title on the left, notification icon and profile avatar on the right
class AppHeader extends StatelessWidget {
  /// The app title to display on the left
  final String appTitle;

  /// Optional callback when notification icon is tapped
  final VoidCallback? onNotificationTap;

  /// Optional callback when profile avatar is tapped
  final VoidCallback? onProfileTap;

  /// Optional profile image URL
  final String? profileImageUrl;

  const AppHeader({
    super.key,
    this.appTitle = 'MindCare',
    this.onNotificationTap,
    this.onProfileTap,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        // Add subtle shadow for depth
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App Title on the left
          Text(
            appTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),

          // Right side: Notification icon and Profile avatar
          Row(
            children: [
              // Notification Icon
              IconButton(
                onPressed: onNotificationTap,
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
                // Add notification badge indicator (optional)
                tooltip: 'Notifications',
              ),

              const SizedBox(width: 8),

              // Profile Avatar
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryLight.withOpacity(0.2),
                    border: Border.all(color: AppColors.primaryLight, width: 2),
                  ),
                  child: profileImageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            profileImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback to icon if image fails to load
                              return const Icon(
                                Icons.person,
                                color: AppColors.primary,
                                size: 24,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 24,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
