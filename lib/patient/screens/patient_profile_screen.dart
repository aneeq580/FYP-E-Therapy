import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1) Profile Header Section
            _buildProfileHeader(),

            const SizedBox(height: AppSizes.spacingLarge),

            // 2) Account Information Section
            _buildAccountInformationSection(),

            const SizedBox(height: AppSizes.spacingLarge),

            // 3) Therapy Activity Section
            _buildTherapyActivitySection(),

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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingLarge),
      color: AppColors.backgroundLight,
      child: Column(
        children: [
          // Circular Profile Avatar (Tappable)
          GestureDetector(
            onTap: () {
              // Navigate to Edit Profile Screen
              // TODO: Create EditProfileScreen and navigate to it
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const EditProfileScreen(),
              //   ),
              // );
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight,
                border: Border.all(color: AppColors.primary, width: 3),
              ),
              child: ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        AppIcons.profile,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSizes.spacingMedium),

          // User Name
          const Text(
            'Aneeq Ahmed',
            style: TextStyle(
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
              const Icon(
                Icons.email_outlined,
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
            icon: const Icon(Icons.edit_outlined, size: 18),
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
            icon: Icons.cake_outlined,
            label: 'Age',
            value: '25 years',
          ),

          const Divider(height: 1, indent: 50),

          // Gender
          _buildInfoRow(
            icon: Icons.person_outline,
            label: 'Gender',
            value: 'Male',
          ),

          const Divider(height: 1, indent: 50),

          // Joined Date
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Joined',
            value: 'January 15, 2024',
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMedium,
        vertical: AppSizes.spacingMedium,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
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

  // Therapy Activity Section Widget
  Widget _buildTherapyActivitySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.only(
              left: AppSizes.spacingMedium,
              bottom: AppSizes.spacingMedium,
            ),
            child: Text(
              'Therapy Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Activity Cards Row
          Row(
            children: [
              Expanded(
                child: _buildActivityCard(
                  icon: FontAwesomeIcons.calendarCheck,
                  title: 'Sessions',
                  value: '12',
                  subtitle: 'Completed',
                  color: AppColors.iconMySessions,
                  backgroundColor: AppColors.iconBgMySessions,
                ),
              ),
              const SizedBox(width: AppSizes.spacingMedium),
              Expanded(
                child: _buildActivityCard(
                  icon: FontAwesomeIcons.clock,
                  title: 'Upcoming',
                  value: '2',
                  subtitle: 'This week',
                  color: AppColors.iconBookSession,
                  backgroundColor: AppColors.iconBgBookSession,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spacingMedium),

          // Mood Check-ins Card
          _buildActivityCard(
            icon: FontAwesomeIcons.faceSmile,
            title: 'Mood Check-ins',
            value: '45',
            subtitle: 'Total entries',
            color: AppColors.iconMoodTracker,
            backgroundColor: AppColors.iconBgMoodTracker,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  // Activity Card Widget
  Widget _buildActivityCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required Color backgroundColor,
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(AppSizes.spacingMedium),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: AppSizes.spacingSmall),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w500),
          ),
          Text(
            subtitle,
            style: AppTextStyles.bodyTextSecondary.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

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
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {},
          ),

          const Divider(height: 1, indent: 50),

          // Privacy & Security
          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: 'Privacy & Security',
            onTap: () {},
          ),

          const Divider(height: 1, indent: 50),

          // Dark Mode (UI toggle only)
          ListTile(
            leading: Icon(Icons.dark_mode_outlined, color: AppColors.primary),
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
              activeColor: AppColors.primary,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacingMedium,
              vertical: 4,
            ),
          ),

          const Divider(height: 1, indent: 50),

          // Language
          _buildSettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'English',
            onTap: () {},
          ),

          const Divider(height: 1, indent: 50),

          // Help & Support
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
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
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: AppTextStyles.bodyTextSecondary)
          : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
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
                // Logout functionality (UI only)
              },
              icon: const Icon(Icons.logout_outlined),
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
