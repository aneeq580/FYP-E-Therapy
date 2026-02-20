import 'package:flutter/material.dart';

class TherapistTodaySessionCard extends StatelessWidget {
  final String patientName;
  final String time;
  final String sessionType;

  const TherapistTodaySessionCard({
    Key? key,
    required this.patientName,
    required this.time,
    required this.sessionType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          /// 👤 Patient Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFF6246EA).withOpacity(0.1),
            child: const Icon(Icons.person_outline, color: Color(0xFF6246EA)),
          ),

          const SizedBox(width: 14),

          /// 📄 Patient Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patientName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "$time • $sessionType",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// 🎥 Join Button
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.video_call_outlined, size: 18),
            label: const Text("Join"),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFF6246EA),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
