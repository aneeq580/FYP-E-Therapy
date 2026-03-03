import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/appointment_controller.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import '../../core/constants/colors.dart';
import '../../models/appointment_model.dart';

class TherapistChatScreen extends StatelessWidget {
  const TherapistChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AppointmentController>()) {
      Get.put(AppointmentController());
    }
    final appointmentController = Get.find<AppointmentController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Clients'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: Obx(() {
        // capture snapshots once to avoid mid-build mutation issues
        final all =
            <AppointmentModel>[
                ...appointmentController.therapistPendingAppointments,
                ...appointmentController.therapistUpcomingAppointments,
              ]
              ..addAll(appointmentController.therapistActiveSessions)
              ..addAll(appointmentController.therapistCompletedAppointments);

        final sessions = all
            .where((s) => s.isActive || s.status == 'completed')
            .toList(growable: false);
        if (sessions.isEmpty) {
          return const Center(child: Text('No chats available'));
        }

        // use concrete children list to avoid any index complaints
        return ListView(
          key: ValueKey(sessions.length),
          children: sessions
              .map(
                (session) => Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        radius: 26,
                        child: Text(
                          session.patientName.isNotEmpty
                              ? session.patientName
                                    .split(' ')
                                    .map((e) => e.isNotEmpty ? e[0] : '')
                                    .where((c) => c.isNotEmpty)
                                    .take(2)
                                    .join()
                              : '?',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        session.patientName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Session on ${session.date.toDate()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chat_bubble_outline),
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.chatDetail,
                          arguments: {
                            'sessionId': session.id,
                            'name': session.patientName,
                          },
                        );
                      },
                    ),
                    const Divider(height: 1),
                  ],
                ),
              )
              .toList(),
        );
      }),
    );
  }
}
