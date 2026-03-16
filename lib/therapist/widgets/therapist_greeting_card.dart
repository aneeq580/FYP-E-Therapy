import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/core/constants/colors.dart';
import '../controllers/therapist_profile_controller.dart';
import '../../controllers/appointment_controller.dart';
import 'therapist_stats_chip.dart';

class TherapistGreetingCard extends StatelessWidget {
  TherapistGreetingCard({super.key});

  final controller = Get.find<TherapistProfileController>();

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning 👋";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon ☀️";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening 🌇";
    } else {
      return "Good Night 🌙";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure AppointmentController is available before using it in Obx
    if (!Get.isRegistered<AppointmentController>()) {
      Get.put(AppointmentController());
    }
    final apptCtrl = Get.find<AppointmentController>();

    return Container(
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            AppColors.therapistPrimary,
            AppColors.therapistSecondary,
          ],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none, // ← allows image to go outside if needed
        children: [
          // Left content with its own padding
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              15,
              20,
              15,
            ), // or just symmetric(20,15)
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getGreeting(),
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Obx(
                  () => Text(
                    controller.fullName.value.isNotEmpty
                        ? controller.fullName.value
                        : "Therapist",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "You are making a \ndifference today 🌿",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  final allAppointments = [
                    ...apptCtrl.therapistActiveSessions,
                    ...apptCtrl.therapistUpcomingAppointments,
                    ...apptCtrl.therapistCompletedAppointments,
                  ];

                  int sessionsCount = allAppointments.length;
                  final uniquePatients = <String>{};
                  for (var appt in allAppointments) {
                    uniquePatients.add(appt.patientId);
                  }
                  int patientsCount = uniquePatients.length;

                  return Row(
                    children: [
                      TherapistStatsChip(
                        title: sessionsCount.toString(),
                        subtitle: "Sessions",
                      ),
                      const SizedBox(width: 8),
                      TherapistStatsChip(
                        title: patientsCount.toString(),
                        subtitle: "Patients",
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),

          // Image now reaches true bottom
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/doctor.png",
              height: 170,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

