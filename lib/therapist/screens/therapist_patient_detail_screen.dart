import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/core/widgets/therapist_app_bar.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/therapist_patient_detail_controller.dart';
import '../../models/appointment_model.dart';
import 'package:intl/intl.dart';
import '../../routes/app_routes.dart';

class TherapistPatientDetailScreen extends StatefulWidget {
  const TherapistPatientDetailScreen({super.key});

  @override
  State<TherapistPatientDetailScreen> createState() =>
      _TherapistPatientDetailScreenState();
}

class _TherapistPatientDetailScreenState
    extends State<TherapistPatientDetailScreen> {
  late final String patientId;
  String? patientName;
  late final TherapistPatientDetailController controller;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    patientId = args['patientId'] as String? ?? '';
    patientName = args['patientName'] as String?;
    controller = Get.put(TherapistPatientDetailController());
    controller.loadProfile(patientId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.therapistBackground,
      appBar: TherapistAppBar(title: patientName ?? 'Patient'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(child: Text('Unable to load patient info.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header with name/email
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.therapistPrimaryLight,
                    child: Text(
                      (patientName != null && patientName!.isNotEmpty)
                          ? patientName![0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patientName ?? 'Patient',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile['email'] ?? '',
                          style: AppTextStyles.bodyTextSecondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Age: ${profile['age'] ?? 'Not set'}'),
              const SizedBox(height: 8),
              Text('Gender: ${profile['gender'] ?? 'Not set'}'),
              const SizedBox(height: 8),
              Text(
                'Joined: ${profile['joinedAt'] != null ? (profile['joinedAt'] as Timestamp).toDate().toLocal().toString().split(' ')[0] : 'Not set'}',
              ),
              const SizedBox(height: 32),
              // Session History Section
              Text(
                'Session History',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              if (controller.patientAppointments.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No sessions yet',
                      style: AppTextStyles.bodyTextSecondary,
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.patientAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = controller.patientAppointments[index];
                    return _SessionHistoryItem(appointment: appointment);
                  },
                ),
            ],
          ),
        );
      }),
    );
  }
}

// Chat-style session history item
class _SessionHistoryItem extends StatelessWidget {
  const _SessionHistoryItem({required this.appointment});

  final AppointmentModel appointment;

  void _openChat() {
    // Only allow opening chat for sessions that have been started or completed
    if (appointment.status == 'started' || appointment.status == 'completed') {
      Get.toNamed(AppRoutes.therapistChat, arguments: appointment.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat(
      'MMM d, yyyy • h:mm a',
    ).format(appointment.date.toDate());
    final duration = '${appointment.duration} min';
    final status = appointment.status;

    // Color based on status
    Color statusColor;
    String statusText;
    switch (status) {
      case 'completed':
        statusColor = Colors.green;
        statusText = 'Completed';
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = 'Cancelled';
        break;
      case 'approved':
      case 'upcoming':
        statusColor = Colors.blue;
        statusText = 'Scheduled';
        break;
      case 'started':
        statusColor = Colors.orange;
        statusText = 'In Progress';
        break;
      default:
        statusColor = Colors.grey;
        statusText = status.capitalizeFirst ?? status;
    }

    // Check if session can be opened
    final canOpenChat = status == 'started' || status == 'completed';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.therapistPrimaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Message bubble
          Expanded(
            child: InkWell(
              onTap: canOpenChat ? _openChat : null,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Session',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (canOpenChat) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 16,
                            color: AppColors.therapistPrimary,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Duration: $duration',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    if (canOpenChat)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Tap to view chat',
                          style: TextStyle(
                            color: AppColors.therapistPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
