import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/widgets/patient_app_bar.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: 'Help & Support'),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spacingMedium),
        children: [
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.circleQuestion,
              color: AppColors.primary,
            ),
            title: const Text('FAQ', style: AppTextStyles.bodyText),
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
              FontAwesomeIcons.envelope,
              color: AppColors.primary,
            ),
            title: const Text('Contact Support', style: AppTextStyles.bodyText),
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
              FontAwesomeIcons.fileContract,
              color: AppColors.primary,
            ),
            title: const Text(
              'Terms of Service',
              style: AppTextStyles.bodyText,
            ),
            trailing: const FaIcon(
              FontAwesomeIcons.chevronRight,
              color: AppColors.textLight,
              size: 16,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
