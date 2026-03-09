import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/appointment_model.dart';
import '../../core/constants/colors.dart';

class TherapistTodaySessionCard extends StatelessWidget {
  final AppointmentModel appointment;
  final String time;
  final String sessionType;
  final VoidCallback? onStart;
  final VoidCallback? onChat;

  const TherapistTodaySessionCard({
    super.key,
    required this.appointment,
    required this.time,
    required this.sessionType,
    this.onStart,
    this.onChat,
  });

  bool get _isSessionActive {
    final s = appointment.status.toLowerCase();
    return s == 'ongoing' || s == 'active' || s == 'started';
  }

  bool get _canStart {
    final now = DateTime.now();
    return now.isAfter(appointment.date.toDate());
  }

  @override
  Widget build(BuildContext context) {
    // Therapist accent color (Purple)
    const therapistAccent = Color(0xFF6246EA);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isSessionActive
              ? therapistAccent
              : AppColors.textLight.withOpacity(0.1),
          width: _isSessionActive ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _isSessionActive
                ? therapistAccent.withOpacity(0.1)
                : Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// 👤 Patient Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: therapistAccent.withOpacity(0.1),
            child: const FaIcon(
              FontAwesomeIcons.user,
              color: therapistAccent,
              size: 18,
            ),
          ),

          const SizedBox(width: 14),

          /// 📄 Patient Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patientName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$time • $sessionType",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// 🔹 Action Button (Start or Chat)
          if (_isSessionActive)
            ElevatedButton.icon(
              onPressed: onChat,
              icon: const FaIcon(FontAwesomeIcons.comments, size: 14),
              label: const Text("Chat"),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: therapistAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            Opacity(
              opacity: _canStart ? 1.0 : 0.5,
              child: ElevatedButton.icon(
                onPressed: _canStart ? onStart : null,
                icon: const FaIcon(FontAwesomeIcons.play, size: 12),
                label: const Text("Start"),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: therapistAccent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: therapistAccent.withOpacity(0.3),
                  disabledForegroundColor: Colors.white.withOpacity(0.7),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
