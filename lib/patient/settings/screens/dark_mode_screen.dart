import 'package:flutter/material.dart';
import '../../../core/widgets/patient_app_bar.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';

class DarkModeScreen extends StatelessWidget {
  const DarkModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: 'Dark Mode'),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spacingMedium),
        children: [
          RadioListTile<String>(
            title: const Text('Light Theme', style: AppTextStyles.bodyText),
            value: 'light',
            groupValue: 'light',
            activeColor: AppColors.primary,
            onChanged: (val) {},
          ),
          const Divider(),
          RadioListTile<String>(
            title: const Text('Dark Theme', style: AppTextStyles.bodyText),
            value: 'dark',
            groupValue: 'light',
            activeColor: AppColors.primary,
            onChanged: (val) {},
          ),
          const Divider(),
          RadioListTile<String>(
            title: const Text('System Default', style: AppTextStyles.bodyText),
            value: 'system',
            groupValue: 'light',
            activeColor: AppColors.primary,
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }
}
