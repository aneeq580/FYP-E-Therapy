import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/widgets/patient_app_bar.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: 'Privacy & Security'),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spacingMedium),
        children: [
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.key,
              color: AppColors.primary,
            ),
            title: const Text('Change Password', style: AppTextStyles.bodyText),
            trailing: const FaIcon(
              FontAwesomeIcons.chevronRight,
              color: AppColors.textLight,
              size: 16,
            ),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.shieldHalved,
              color: AppColors.primary,
            ),
            title: const Text('Data Privacy', style: AppTextStyles.bodyText),
            trailing: const FaIcon(
              FontAwesomeIcons.chevronRight,
              color: AppColors.textLight,
              size: 16,
            ),
            onTap: () {},
          ),
          const Divider(),
          SwitchListTile(
            title: const Text(
              'Two-Factor Authentication',
              style: AppTextStyles.bodyText,
            ),
            value: false,
            activeColor: AppColors.primary,
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }
}
