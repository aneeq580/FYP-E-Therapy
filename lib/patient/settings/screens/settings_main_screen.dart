import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../core/widgets/patient_app_bar.dart';
import '../../profile/settings_tile.dart';
import '../widgets/settings_card.dart';

class SettingsMainScreen extends StatelessWidget {
  const SettingsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacingMedium),
        child: Column(
          children: [
            SettingsCard(
              title: 'General',
              tiles: [
                SettingsTile(
                  icon: FontAwesomeIcons.bell,
                  title: 'Notifications',
                  onTap: () =>
                      Get.toNamed(AppRoutes.patientSettingsNotifications),
                ),
                SettingsTile(
                  icon: FontAwesomeIcons.lock,
                  title: 'Privacy & Security',
                  onTap: () => Get.toNamed(AppRoutes.patientSettingsPrivacy),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            SettingsCard(
              title: 'Preferences',
              tiles: [
                SettingsTile(
                  icon: FontAwesomeIcons.moon,
                  title: 'Dark Mode',
                  onTap: () => Get.toNamed(AppRoutes.patientSettingsDarkMode),
                ),
                SettingsTile(
                  icon: FontAwesomeIcons.language,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () => Get.toNamed(AppRoutes.patientSettingsLanguage),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            SettingsCard(
              title: 'Support',
              tiles: [
                SettingsTile(
                  icon: FontAwesomeIcons.circleQuestion,
                  title: 'Help & Support',
                  onTap: () => Get.toNamed(AppRoutes.patientSettingsHelp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
