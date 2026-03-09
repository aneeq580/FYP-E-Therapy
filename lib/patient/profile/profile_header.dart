import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import 'widgets/profile_avatar_widget.dart';

class ProfileHeader extends StatelessWidget {
  final String displayName;
  final String? subtitle;
  final String? profileImageUrl;
  final String gender;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onEditTap;

  const ProfileHeader({
    super.key,
    required this.displayName,
    this.subtitle,
    this.profileImageUrl,
    required this.gender,
    this.onAvatarTap,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingLarge),
      color: AppColors.backgroundLight,
      child: Column(
        children: [
          ProfileAvatarWidget(
            profileImageUrl: profileImageUrl,
            displayName: displayName,
            gender: gender,
            onAvatarTap: onAvatarTap,
            onEditTap: onEditTap,
          ),

          const SizedBox(height: AppSizes.spacingMedium),

          Text(
            displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          if (subtitle != null) ...[
            const SizedBox(height: AppSizes.spacingSmall),
            Text(subtitle!, style: AppTextStyles.bodyTextSecondary),
          ],

          const SizedBox(height: AppSizes.spacingMedium),
        ],
      ),
    );
  }
}
