import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FaIcon(icon, color: iconColor ?? AppColors.iconSettings),
      title: Text(
        title,
        style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AppTextStyles.bodyTextSecondary)
          : null,
      trailing: const FaIcon(
        FontAwesomeIcons.chevronRight,
        color: AppColors.textLight,
      ),
      onTap: onTap ?? () {},
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMedium,
        vertical: 4,
      ),
    );
  }
}
