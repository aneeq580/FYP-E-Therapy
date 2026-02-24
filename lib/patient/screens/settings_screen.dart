import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/patient_app_bar.dart';
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
      appBar: const PatientAppBar(title: 'Settings'),
      body: ListView(
        children: [
          const SizedBox(height: AppSizes.spacingSmall),

          // Notifications
          SettingsTile(
            icon: FontAwesomeIcons.bell,
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
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.moon,
                  color: AppColors.primary,
                  size: 20,
                ),
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
            icon: FontAwesomeIcons.language,
            title: 'Language',
            subtitle: 'English',
            onTap: _handleLanguage,
          ),

          const Divider(height: 1, indent: 70),

          // Privacy Policy
          SettingsTile(
            icon: FontAwesomeIcons.shieldAlt,
            title: 'Privacy Policy',
            subtitle: 'View our privacy policy',
            onTap: _handlePrivacyPolicy,
          ),

          const Divider(height: 1, indent: 70),

          // About App
          SettingsTile(
            icon: FontAwesomeIcons.infoCircle,
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
