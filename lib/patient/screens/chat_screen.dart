import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import 'package:fyp_therapy/controllers/appointment_controller.dart';
import '../../core/widgets/patient_app_bar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AppointmentController>()) {
      Get.put(AppointmentController());
    }
    final appointmentController = Get.find<AppointmentController>();
    return Scaffold(
      appBar: const PatientAppBar(title: 'Messages'),
      body: Obx(() {
        final all = appointmentController.patientAppointments.toList();
        // include active sessions plus completed ones
        final sessions = all
            .where((s) => s.isActive || s.status == 'completed')
            .toList();
        if (sessions.isEmpty) {
          return const Center(child: Text('No chats available'));
        }
        return ListView.separated(
          itemCount: sessions.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final session = sessions[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                radius: 26,
                child: Text(
                  session.therapistName
                      .split(' ')
                      .map((e) => e[0])
                      .take(2)
                      .join(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                session.therapistName,
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
                    'name': session.therapistName,
                  },
                );
              },
            );
          },
        );
      }),
    );
  }
}
