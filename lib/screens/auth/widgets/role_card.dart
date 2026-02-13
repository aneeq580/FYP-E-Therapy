import 'package:flutter/material.dart';

/// Role selection card widget
///
/// Features:
/// - Displays role option (Patient/Therapist) with icon
/// - Selectable state with visual feedback
/// - Soft color scheme
class RoleCard extends StatelessWidget {
  final String roleName;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final String description;

  const RoleCard({
    Key? key,
    required this.roleName,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? const Color(0xFF7B68C0)
                : const Color(0xFFE0E6ED),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? const Color(0xFFF0EBF8) : const Color(0xFFFAFBFC),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF7B68C0).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFF7B68C0)
                    : const Color(0xFFE8EEF5),
              ),
              child: Icon(
                icon,
                size: 32,
                color: isSelected ? Colors.white : const Color(0xFF5A6B7E),
              ),
            ),
            const SizedBox(height: 16),
            // Role name
            Text(
              roleName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF5A6B7E),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
