import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';

class ProfileHeader extends StatelessWidget {
  final String displayName;
  final String? subtitle;
  final String? profileImageUrl;
  final VoidCallback? onEditTap;

  const ProfileHeader({
    super.key,
    required this.displayName,
    this.subtitle,
    this.profileImageUrl,
    this.onEditTap,
  });

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp('\\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Widget _initialsAvatar(String name, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
      ),
      child: Center(
        child: Text(
          _initials(name),
          style: TextStyle(
            color: AppColors.textOnPrimary,
            fontSize: size * 0.36,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const size = 100.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingLarge),
      color: AppColors.backgroundLight,
      child: Column(
        children: [
          GestureDetector(
            onTap: onEditTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 3),
                  ),
                  child: ClipOval(
                    child: profileImageUrl != null
                        ? Image.network(
                            profileImageUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return _initialsAvatar(displayName, size);
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return _initialsAvatar(displayName, size);
                            },
                          )
                        : _initialsAvatar(displayName, size),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.backgroundLight,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimary.withOpacity(0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ],
            ),
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
