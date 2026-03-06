import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/appointment_controller.dart';
import '../screens/chat_screen.dart';
import '../../core/widgets/role_based_session_card.dart';
import '../../core/constants/styles.dart';

/// Displays currently active/started sessions for either patient or therapist.
///
/// The list updates in real time via the existing AppointmentController streams.
class SessionsListScreen extends StatelessWidget {
  const SessionsListScreen({super.key, required this.isTherapist});

  final bool isTherapist;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AppointmentController>()) {
      Get.put(AppointmentController());
    }
    final controller = Get.find<AppointmentController>();

    // choose the right observable list
    final sessionsObs = isTherapist
        ? controller.therapistActiveSessions
        : controller.patientOngoingSessions;

    return Scaffold(
      appBar: AppBar(
        title: Text(isTherapist ? 'Active Sessions' : 'My Active Sessions'),
      ),
      body: Obx(() {
        final sessions = sessionsObs.toList();
        if (sessions.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spacingLarge),
              child: Text(
                isTherapist
                    ? 'No sessions have been started yet.'
                    : 'No active sessions in progress.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyTextSecondary.copyWith(fontSize: 16),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            return RoleBasedSessionCard(
              appointment: session,
              role: isTherapist ? 'therapist' : 'patient',
              onTap: () {
                Get.to(
                  () => ChatScreen(
                    sessionId: session.id,
                    isTherapist: isTherapist,
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
