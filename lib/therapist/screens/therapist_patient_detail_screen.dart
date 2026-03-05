import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/therapist_patient_detail_controller.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(patientName ?? 'Patient'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
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
                    backgroundColor: AppColors.primaryLight,
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
              const SizedBox(height: 24),
              // additional sections could go here
            ],
          ),
        );
      }),
    );
  }
}
