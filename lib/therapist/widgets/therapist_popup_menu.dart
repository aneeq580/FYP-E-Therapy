import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/colors.dart';

class TherapistPopupMenu extends StatelessWidget {
  final Function(String) onSelected;

  const TherapistPopupMenu({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      icon: CircleAvatar(
        radius: 16,
        backgroundColor: AppColors.therapistPrimary,
        child: FaIcon(FontAwesomeIcons.bars, size: 18, color: Colors.white),
      ),
      onSelected: onSelected,
      itemBuilder: (context) => [
        _buildItem(
          FontAwesomeIcons.calendar,
          "Manage Availability",
          "availability",
        ),
        _buildItem(FontAwesomeIcons.user, "My Profile", "profile"),
        _buildItem(FontAwesomeIcons.gear, "Settings", "settings"),
        const PopupMenuDivider(),
        _buildItem(
          FontAwesomeIcons.rightFromBracket,
          "Logout",
          "logout",
          isDanger: true,
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildItem(
    IconData icon,
    String text,
    String value, {
    bool isDanger = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          FaIcon(
            icon,
            size: 20,
            color: isDanger ? AppColors.iconEmergency : AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDanger ? AppColors.iconEmergency : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
