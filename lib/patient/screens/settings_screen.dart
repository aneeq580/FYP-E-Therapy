import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/settings_tile.dart';

/// Settings Screen - App settings and preferences
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // UI only state for Dark Mode toggle
  bool _isDarkMode = false;

  void _handleNotifications() {
    // TODO: Navigate to notifications settings screen
    // Navigator.push(context, ...);
  }

  void _handleLanguage() {
    // TODO: Show language selection dialog or navigate to language screen
    // showDialog(...);
  }

  void _handlePrivacyPolicy() {
    // TODO: Navigate to privacy policy screen or open web view
    // Navigator.push(context, ...);
  }

  void _handleAboutApp() {
    // TODO: Show about app dialog or navigate to about screen
    // showDialog(...);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: AppSizes.spacingSmall),

          // Notifications
          SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage your notification preferences',
            onTap: _handleNotifications,
          ),

          const Divider(height: 1, indent: 70),

          // Dark Mode
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.dark_mode_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            title: Text(
              'Dark Mode',
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Switch to dark theme',
              style: AppTextStyles.bodyTextSecondary.copyWith(fontSize: 12),
            ),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value; // UI only, no logic
                });
              },
              activeColor: AppColors.primary,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacingMedium,
              vertical: 4,
            ),
          ),

          const Divider(height: 1, indent: 70),

          // Language
          SettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'English',
            onTap: _handleLanguage,
          ),

          const Divider(height: 1, indent: 70),

          // Privacy Policy
          SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'View our privacy policy',
            onTap: _handlePrivacyPolicy,
          ),

          const Divider(height: 1, indent: 70),

          // About App
          SettingsTile(
            icon: Icons.info_outline,
            title: 'About App',
            subtitle: 'Version 1.0.0',
            onTap: _handleAboutApp,
          ),

          const SizedBox(height: AppSizes.spacingLarge),
        ],
      ),
    );
  }
}
