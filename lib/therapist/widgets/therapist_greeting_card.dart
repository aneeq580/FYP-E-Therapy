import 'package:flutter/material.dart';
import 'therapist_stats_chip.dart';

class TherapistGreetingCard extends StatelessWidget {
  const TherapistGreetingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7F5AF0),
            Color(0xFF6246EA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [

          Text(
            "Good Morning 👋",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          SizedBox(height: 6),

          Text(
            "Dr. Ahmed",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 12),

          Text(
            "You are making a difference today 🌿",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),

          SizedBox(height: 20),

          Row(
            children: [
              TherapistStatsChip(
                title: "3",
                subtitle: "Sessions",
              ),
              SizedBox(width: 12),
              TherapistStatsChip(
                title: "24",
                subtitle: "Patients",
              ),
            ],
          )
        ],
      ),
    );
  }
}
