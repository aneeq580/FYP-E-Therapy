import 'package:flutter/material.dart';
import '../../../core/widgets/patient_app_bar.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: 'Language'),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spacingMedium),
        children: [
          RadioListTile<String>(
            title: const Text('English', style: AppTextStyles.bodyText),
            value: 'en',
            groupValue: 'en',
            activeColor: AppColors.primary,
            onChanged: (val) {},
          ),
          const Divider(),
          RadioListTile<String>(
            title: const Text('Spanish', style: AppTextStyles.bodyText),
            value: 'es',
            groupValue: 'en',
            activeColor: AppColors.primary,
            onChanged: (val) {},
          ),
          const Divider(),
          RadioListTile<String>(
            title: const Text('French', style: AppTextStyles.bodyText),
            value: 'fr',
            groupValue: 'en',
            activeColor: AppColors.primary,
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }
}
