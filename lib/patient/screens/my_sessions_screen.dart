import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/patient_app_bar.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/role_based_session_card.dart';
import '../../controllers/appointment_controller.dart';
import '../../models/appointment_model.dart';

/// My Sessions Screen - Patient view with 4 status tabs.
class MySessionsScreen extends StatelessWidget {
  const MySessionsScreen({super.key});

  // These are handled by the new RoleBasedSessionCard now!

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.self_improvement_rounded,
              size: 56,
              color: AppColors.textSecondary.withOpacity(0.6),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyTextSecondary.copyWith(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionList(
    List<AppointmentModel> sessions,
    String filterStatus,
  ) {
    // Upcoming tab should match 'approved', 'upcoming' and 'active' statuses from firestore
    final bool isUpcomingTab = filterStatus.toLowerCase() == 'approved';

    final items = sessions.where((s) {
      final status = s.status.toLowerCase();
      if (isUpcomingTab) {
        return status == 'approved' ||
            status == 'upcoming' ||
            status == 'active';
      }
      return status == filterStatus.toLowerCase();
    }).toList();

    if (items.isEmpty) {
      return _buildEmptyState(
        'No sessions here yet.\nNew bookings will appear in this tab.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: AppSizes.spacingMedium,
        bottom: AppSizes.spacingLarge,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final session = items[index];
        return RoleBasedSessionCard(
          appointment: session,
          role: 'patient',
          onTap: () {
            // Navigate to session details
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AppointmentController>()) {
      Get.put(AppointmentController());
    }
    final controller = Get.find<AppointmentController>();
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const PatientAppBar(title: 'My Sessions'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.spacingMedium),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingMedium,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  labelColor: AppColors.textOnPrimary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicator: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  labelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: 'Pending'),
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Completed'),
                    Tab(text: 'Cancelled'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spacingMedium),
            Expanded(
              child: Obx(() {
                final sessions = controller.patientAppointments.toList();
                return TabBarView(
                  children: [
                    _buildSessionList(sessions, 'pending'),
                    _buildSessionList(sessions, 'approved'),
                    _buildSessionList(sessions, 'completed'),
                    _buildSessionList(sessions, 'cancelled'),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
