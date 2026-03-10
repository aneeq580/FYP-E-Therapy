import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/patient_app_bar.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/role_based_session_card.dart';
import '../../controllers/appointment_controller.dart';
import '../../models/appointment_model.dart';
import 'package:fyp_therapy/chat/screens/chat_screen.dart';

/// My Sessions Screen - Patient view with 5 status tabs.
class MySessionsScreen extends StatelessWidget {
  const MySessionsScreen({super.key});

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

  // ── 1. PENDING TAB ────────────────────────────────────────────────────────
  Widget _buildPendingList(List<AppointmentModel> sessions) {
    final items = sessions
        .where((s) => s.status.toLowerCase() == 'pending')
        .toList();
    if (items.isEmpty) {
      return _buildEmptyState(
        'No pending requests.\nBooked sessions waiting for therapist approval appear here.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: AppSizes.spacingMedium,
        bottom: AppSizes.spacingLarge,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) =>
          RoleBasedSessionCard(appointment: items[index], role: 'patient'),
    );
  }

  // ── 2. UPCOMING TAB (approved/accepted sessions) ──────────────────────────
  Widget _buildUpcomingList(List<AppointmentModel> sessions) {
    final items = sessions.where((s) {
      final status = s.status.toLowerCase();
      return status == 'approved' || status == 'upcoming';
    }).toList();

    if (items.isEmpty) {
      return _buildEmptyState(
        'No upcoming sessions.\nAccepted sessions will appear here.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: AppSizes.spacingMedium,
        bottom: AppSizes.spacingLarge,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) =>
          RoleBasedSessionCard(appointment: items[index], role: 'patient'),
    );
  }

  // ── 3. ONGOING TAB (started/active sessions) ──────────────────────────────
  Widget _buildOngoingList(List<AppointmentModel> ongoingSessions) {
    if (ongoingSessions.isEmpty) {
      return _buildEmptyState(
        'No ongoing sessions right now.\nActive sessions will appear here.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: AppSizes.spacingMedium,
        bottom: AppSizes.spacingLarge,
      ),
      itemCount: ongoingSessions.length,
      itemBuilder: (context, index) {
        final session = ongoingSessions[index];
        return RoleBasedSessionCard(
          appointment: session,
          role: 'patient',
          onTap: () => Get.to(
            () => ChatScreen(sessionId: session.id, isTherapist: false),
          ),
        );
      },
    );
  }

  // ── 4. COMPLETED TAB ──────────────────────────────────────────────────────
  Widget _buildCompletedList(List<AppointmentModel> sessions) {
    final items = sessions
        .where((s) => s.status.toLowerCase() == 'completed')
        .toList();
    if (items.isEmpty) {
      return _buildEmptyState('No completed sessions yet.');
    }
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: AppSizes.spacingMedium,
        bottom: AppSizes.spacingLarge,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) =>
          RoleBasedSessionCard(appointment: items[index], role: 'patient'),
    );
  }

  // ── 5. CANCELLED TAB ──────────────────────────────────────────────────────
  Widget _buildCancelledList(List<AppointmentModel> sessions) {
    final items = sessions
        .where((s) => s.status.toLowerCase() == 'cancelled')
        .toList();
    if (items.isEmpty) {
      return _buildEmptyState('No cancelled sessions.');
    }
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: AppSizes.spacingMedium,
        bottom: AppSizes.spacingLarge,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) =>
          RoleBasedSessionCard(appointment: items[index], role: 'patient'),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AppointmentController>()) {
      Get.put(AppointmentController());
    }
    final controller = Get.find<AppointmentController>();

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const PatientAppBar(title: 'My Sessions'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.spacingSmall),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingSmall),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  padding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 3,
                  ),
                  labelColor: AppColors.textOnPrimary,
                  unselectedLabelColor: AppColors.textSecondary,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: 'Pending'),
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Ongoing'),
                    Tab(text: 'Completed'),
                    Tab(text: 'Cancelled'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spacingMedium),
            Expanded(
              child: Obx(() {
                final allSessions = controller.patientAppointments.toList();
                final ongoingSessions = controller.patientOngoingSessions
                    .toList();
                return TabBarView(
                  children: [
                    _buildPendingList(allSessions),
                    _buildUpcomingList(allSessions),
                    _buildOngoingList(ongoingSessions),
                    _buildCompletedList(allSessions),
                    _buildCancelledList(allSessions),
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
