import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/auth_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/patient_app_bar.dart';
import '../../controllers/patient_activity_controller.dart';
import '../widgets/therapy_activity_card.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Register PatientActivityController if not yet in the GetX registry.
    // Using Get.put (not lazyPut) so it is immediately available for TherapyActivityCard.
    if (!Get.isRegistered<PatientActivityController>()) {
      Get.put(PatientActivityController(), permanent: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1) Profile Header Section
            _buildProfileHeader(),

            const SizedBox(height: AppSizes.spacingLarge),

            // 2) Account Information Section
            _buildAccountInformationSection(),

            const SizedBox(height: AppSizes.spacingLarge),

            // 3) Therapy Activity Section (real-time)
            const TherapyActivityCard(),

            const SizedBox(height: AppSizes.spacingLarge),

            // 4) Settings Section
            _buildSettingsSection(),

            const SizedBox(height: AppSizes.spacingLarge),

            // 5) Logout Section
            _buildLogoutSection(),

            const SizedBox(height: AppSizes.spacingLarge),
          ],
        ),
      ),
    );
  }

  // Profile Header Widget
  Widget _buildProfileHeader() {
    const displayName = 'Aneeq Ahmed';
    const imageUrl =
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face';

    String initials(String name) {
      final parts = name
          .trim()
          .split(RegExp('\\s+'))
          .where((s) => s.isNotEmpty)
          .toList();
      if (parts.isEmpty) return '';
      if (parts.length == 1) return parts.first[0].toUpperCase();
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }

    Widget initialsAvatar(String name, double size) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
        child: Center(
          child: Text(
            initials(name),
            style: TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: size * 0.36,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingLarge),
      color: AppColors.backgroundLight,
      child: Column(
        children: [
          // Circular Profile Avatar with edit overlay
          GestureDetector(
            onTap: () {
              // TODO: Open image picker / edit profile
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 3),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return initialsAvatar(displayName, 100);
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return initialsAvatar(displayName, 100);
                      },
                    ),
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
                    child: const FaIcon(
                      FontAwesomeIcons.pen,
                      size: 18,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spacingMedium),

          // User Name
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: AppSizes.spacingSmall),

          // Email or Role
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.envelope,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text('aneeq@example.com', style: AppTextStyles.bodyTextSecondary),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Patient',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spacingMedium),

          // Edit Profile Button
          ElevatedButton.icon(
            onPressed: () {
              // Edit Profile functionality (UI only)
            },
            icon: const FaIcon(FontAwesomeIcons.pen, size: 18),
            label: const Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Account Information Section Widget
  Widget _buildAccountInformationSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.all(AppSizes.spacingMedium),
            child: Text(
              'Account Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          const Divider(height: 1),

          // Age
          _buildInfoRow(
            icon: FontAwesomeIcons.cake,
            label: 'Age',
            value: '25 years',
            iconColor: AppColors.iconMySessions,
          ),

          const Divider(height: 1, indent: 50),

          // Gender
          _buildInfoRow(
            icon: FontAwesomeIcons.user,
            label: 'Gender',
            value: 'Male',
            iconColor: AppColors.iconMoodTracker,
          ),

          const Divider(height: 1, indent: 50),

          // Joined Date
          _buildInfoRow(
            icon: FontAwesomeIcons.calendar,
            label: 'Joined',
            value: 'January 15, 2024',
            iconColor: AppColors.iconResources,
          ),
        ],
      ),
    );
  }

  // Info Row Widget (reusable for Account Information)
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color iconColor = AppColors.iconMySessions,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMedium,
        vertical: AppSizes.spacingMedium,
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 20, color: iconColor),
          const SizedBox(width: AppSizes.spacingMedium),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(value, style: AppTextStyles.bodyTextSecondary),
        ],
      ),
    );
  }

  // ── Removed: _buildTherapyActivitySection() and _buildActivityCard() ──────
  // These have been replaced by TherapyActivityCard + ActivityItem widgets.

  // Settings Section Widget
  Widget _buildSettingsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.all(AppSizes.spacingMedium),
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          const Divider(height: 1),

          // Notifications
          _buildSettingsTile(
            icon: FontAwesomeIcons.bell,
            title: 'Notifications',
            onTap: () {},
            iconColor: AppColors.iconChat,
          ),

          const Divider(height: 1, indent: 50),

          // Privacy & Security
          _buildSettingsTile(
            icon: FontAwesomeIcons.lock,
            title: 'Privacy & Security',
            onTap: () {},
            iconColor: AppColors.iconSettings,
          ),

          const Divider(height: 1, indent: 50),

          // Dark Mode (UI toggle only)
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.moon,
              color: AppColors.iconMoodTracker,
            ),
            title: Text(
              'Dark Mode',
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Switch(
              value: false, // UI only, no logic
              onChanged: (value) {
                // UI only, no functionality
              },
              activeColor: AppColors.iconMoodTracker,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacingMedium,
              vertical: 4,
            ),
          ),

          const Divider(height: 1, indent: 50),

          // Language
          _buildSettingsTile(
            icon: FontAwesomeIcons.language,
            title: 'Language',
            subtitle: 'English',
            onTap: () {},
            iconColor: AppColors.iconResources,
          ),

          const Divider(height: 1, indent: 50),

          // Help & Support
          _buildSettingsTile(
            icon: FontAwesomeIcons.circleQuestion,
            title: 'Help & Support',
            onTap: () {},
            iconColor: AppColors.iconBookSession,
          ),
        ],
      ),
    );
  }

  // Settings Tile Widget (reusable)
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color iconColor = AppColors.iconSettings,
  }) {
    return ListTile(
      leading: FaIcon(icon, color: iconColor),
      title: Text(
        title,
        style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: AppTextStyles.bodyTextSecondary)
          : null,
      trailing: const FaIcon(
        FontAwesomeIcons.chevronRight,
        color: AppColors.textLight,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMedium,
        vertical: 4,
      ),
    );
  }

  // Logout Section Widget
  Widget _buildLogoutSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
      child: Column(
        children: [
          // Visual Separator
          Container(
            height: 1,
            color: AppColors.textLight.withOpacity(0.3),
            margin: const EdgeInsets.only(bottom: AppSizes.spacingLarge),
          ),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                final authController = Get.find<AuthController>();
                authController.handleLogout();
              },
              icon: const FaIcon(FontAwesomeIcons.rightFromBracket),
              label: const Text(
                'Logout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
