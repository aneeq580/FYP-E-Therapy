import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/therapist_app_bar.dart';
import '../../core/widgets/therapist_appointment_card.dart';
import '../../controllers/appointment_controller.dart';
import '../../routes/app_routes.dart';

/// A simple list of appointments grouped by patient. Tapping on a card
/// opens a detail page showing the patient profile (loaded from Firestore).
class TherapistPatientsScreen extends StatefulWidget {
  const TherapistPatientsScreen({super.key});

  @override
  State<TherapistPatientsScreen> createState() =>
      _TherapistPatientsScreenState();
}

class _TherapistPatientsScreenState extends State<TherapistPatientsScreen> {
  late AppointmentController _appointmentController;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<AppointmentController>()) {
      Get.put(AppointmentController());
    }
    _appointmentController = Get.find<AppointmentController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const TherapistAppBar(title: 'My Patients'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final upcoming = _appointmentController.therapistUpcomingAppointments;
          if (upcoming.isEmpty) {
            return const Center(child: Text('No patients booked yet.'));
          }
          return ListView.separated(
            itemCount: upcoming.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final appointment = upcoming[index];
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Get.toNamed(
                    AppRoutes.therapistPatientDetail,
                    arguments: {
                      'patientId': appointment.patientId,
                      'patientName': appointment.patientName,
                    },
                  );
                },
                child: TherapistAppointmentCard(
                  appointment: appointment,
                  // no action buttons here, cards are tappable instead
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
