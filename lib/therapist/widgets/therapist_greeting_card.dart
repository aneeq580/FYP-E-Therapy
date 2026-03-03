import 'package:flutter/material.dart';
import 'therapist_stats_chip.dart';

class TherapistGreetingCard extends StatelessWidget {
  const TherapistGreetingCard({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning 👋";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon ☀️";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening 🌇";
    } else {
      return "Good Night 🌙";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            // ignore: deprecated_member_use
            Color(0xFF7F5AF0).withOpacity(0.9),
            // ignore: deprecated_member_use
            Color(0xFF6246EA).withOpacity(0.9), // gentle green/purple mix
          ],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none, // ← allows image to go outside if needed
        children: [
          // Left content with its own padding
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              15,
              20,
              15,
            ), // or just symmetric(20,15)
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getGreeting(),
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Dr. Ahmed",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "You are making a \ndifference today 🌿",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    TherapistStatsChip(title: "3", subtitle: "Sessions"),
                    SizedBox(width: 8),
                    TherapistStatsChip(title: "24", subtitle: "Patients"),
                  ],
                ),
              ],
            ),
          ),

          // Image now reaches true bottom
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/doctor.png",
              height: 170,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
