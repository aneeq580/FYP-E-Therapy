import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fyp_therapy/core/widgets/therapist_app_bar.dart';
import '../../core/constants/colors.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../controllers/appointment_controller.dart';

class AppointmentRequestsScreen extends StatefulWidget {
  const AppointmentRequestsScreen({super.key});

  @override
  State<AppointmentRequestsScreen> createState() =>
      _AppointmentRequestsScreenState();
}

class _AppointmentRequestsScreenState extends State<AppointmentRequestsScreen> {
  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<AppointmentController>()) {
      Get.put(AppointmentController());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.therapistBackground,
      appBar: const TherapistAppBar(title: 'Appointment Requests'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.calendar,
                  size: 36,
                  color: AppColors.therapistPrimary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Pending Requests',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Obx(() {
                  final pendingCount = Get.find<AppointmentController>()
                      .therapistPendingAppointments
                      .length;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.therapistPrimary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$pendingCount pending',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.therapistPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }),
              ],
            ),

            const SizedBox(height: 16),

            const SizedBox(height: 16),

            // View all button
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.pendingSessions);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.therapistPrimary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('View All Requests'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
