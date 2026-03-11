import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../core/constants/colors.dart';
import '../../models/appointment_model.dart';
import '../../controllers/appointment_controller.dart';
import '../../core/widgets/therapist_app_bar.dart';
import 'package:intl/intl.dart';

class PendingSessionsScreen extends StatelessWidget {
  const PendingSessionsScreen({super.key});

  AppointmentController get _appointmentController {
    if (!Get.isRegistered<AppointmentController>()) {
      Get.put(AppointmentController());
    }
    return Get.find<AppointmentController>();
  }

  String _formatDate(AppointmentModel session) {
    final dt = session.date.toDate();
    return DateFormat('E dd').format(dt);
  }

  String _formatTime(AppointmentModel session) {
    final dt = session.date.toDate();
    return DateFormat('h:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.therapistBackground,
      appBar: const TherapistAppBar(title: 'Pending Session Requests'),
      body: Obx(() {
        final pending = _appointmentController.therapistPendingAppointments;

        if (pending.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inbox_rounded,
                    size: 60,
                    color: AppColors.textSecondary.withOpacity(0.6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No pending session requests',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'New patient requests will appear here in real time.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pending.length,
          itemBuilder: (context, index) {
            final session = pending[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: AppColors.therapistPrimary.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.therapistPrimary.withOpacity(0.08),
                          child: const FaIcon(
                            FontAwesomeIcons.user,
                            size: 18,
                            color: AppColors.therapistPrimary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session.patientName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_formatDate(session)} • ${_formatTime(session)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    /* if (session.reason != null && session.reason!.isNotEmpty)
                      Text(
                        session.reason!,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary.withOpacity(0.8),
                        ),
                      ),
                    if (session.reason != null && session.reason!.isNotEmpty)
                      const SizedBox(height: 10), */
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _appointmentController.rejectAppointment(
                                session.id,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: BorderSide(
                                color: AppColors.error.withOpacity(0.6),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const FaIcon(
                              FontAwesomeIcons.xmark,
                              size: 14,
                            ),
                            label: const Text('Reject'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _appointmentController.acceptAppointment(
                                session.id,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.therapistPrimary,
                              foregroundColor: AppColors.textOnPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const FaIcon(
                              FontAwesomeIcons.check,
                              size: 14,
                            ),
                            label: const Text('Accept'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
