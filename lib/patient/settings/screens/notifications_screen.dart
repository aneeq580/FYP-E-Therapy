import 'package:flutter/material.dart';
import '../../../core/widgets/patient_app_bar.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: 'Notifications'),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spacingMedium),
        children: [
          SwitchListTile(
            title: const Text(
              'Push Notifications',
              style: AppTextStyles.bodyText,
            ),
            subtitle: const Text(
              'Receive alerts on your device',
              style: AppTextStyles.bodyTextSecondary,
            ),
            value: true,
            activeThumbColor: AppColors.primary,
            onChanged: (val) {},
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Email Reminders', style: AppTextStyles.bodyText),
            subtitle: const Text(
              'Receive session reminders via email',
              style: AppTextStyles.bodyTextSecondary,
            ),
            value: false,
            activeThumbColor: AppColors.primary,
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }
}
