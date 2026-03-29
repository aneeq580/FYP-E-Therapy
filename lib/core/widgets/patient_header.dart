import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/colors.dart';

class PatientHeader extends StatelessWidget {
  final String username;
  final String? subtitle;
  final String? profileImageUrl;
  final VoidCallback? onProfileTap;
  final Function(String emoji)? onMoodSelected;
  final String? selectedEmoji;
  final VoidCallback? onQuickBreatheTap;

  const PatientHeader({
    super.key,
    required this.username,
    this.subtitle,
    this.profileImageUrl,
    this.onProfileTap,
    this.onMoodSelected,
    this.selectedEmoji,
    this.onQuickBreatheTap,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Line
          Text(
            "${_getGreeting()}, $username!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),

          // Motivational / Empathetic Line
          Text(
            "Take a moment for yourself today 💙",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Quick Mood Check-in
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMoodButton("😄", "Great"),
              _buildMoodButton("😊", "Happy"),
              _buildMoodButton("😐", "Okay"),
              _buildMoodButton("🙂", "Good"),
              _buildMoodButton("😢", "Sad"),
            ],
          ),
          const SizedBox(height: 5),

          // Optional Quick Action Button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: const FaIcon(
                FontAwesomeIcons.wind,
                color: Colors.white,
                size: 14,
              ),
              label: const Text(
                "Quick Breathe",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.25),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, color: Colors.white),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
              ),
              onPressed: onQuickBreatheTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodButton(String emoji, String label) {
    final isSelected = selectedEmoji == emoji;
    return GestureDetector(
      onTap: () {
        if (onMoodSelected != null) {
          onMoodSelected!(emoji);
        }
      },
      child: AnimatedScale(
        scale: isSelected ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
