import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/colors.dart';

class PatientHeader extends StatelessWidget {
  final String username;
  final String? subtitle;
  final String? profileImageUrl;
  final VoidCallback? onProfileTap;

  const PatientHeader({
    super.key,
    required this.username,
    this.subtitle,
    this.profileImageUrl,
    this.onProfileTap,
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
          const SizedBox(height: 5),

          // Quick Mood Check-in (Recommended – bohot engaging banata hai)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMoodButton("😊", "Happy", Colors.greenAccent),
              _buildMoodButton("😐", "Okay", Colors.amber),
              _buildMoodButton("😟", "Anxious", Colors.orange),
              _buildMoodButton("😔", "Sad", Colors.blueGrey),
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
              onPressed: () {
                // Navigate to breathing exercise screen
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodButton(String emoji, String label, Color color) {
    return GestureDetector(
      onTap: () {
        // TODO: Save mood to local/Firestore + show snackbar "Mood logged!"
        print("Mood selected: $label");
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
          // const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
