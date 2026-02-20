import 'package:flutter/material.dart';

class TherapistPopupMenu extends StatelessWidget {
  final Function(String) onSelected;

  const TherapistPopupMenu({Key? key, required this.onSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      icon: const CircleAvatar(
        radius: 16,
        backgroundColor: Color(0xFF7F5AF0),
        child: Icon(Icons.menu, size: 18, color: Colors.white),
      ),
      onSelected: onSelected,
      itemBuilder: (context) => [
        _buildItem(Icons.schedule, "Manage Availability", "availability"),
        _buildItem(Icons.person_outline, "My Profile", "profile"),
        _buildItem(Icons.settings_outlined, "Settings", "settings"),
        const PopupMenuDivider(),
        _buildItem(Icons.logout, "Logout", "logout", isDanger: true),
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
          Icon(icon, size: 20, color: isDanger ? Colors.red : Colors.grey[700]),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDanger ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
