import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/role_based_session_card.dart';
import '../../controllers/appointment_controller.dart';
import '../../models/appointment_model.dart';
import '../../core/widgets/therapist_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TherapistAppointmentsScreen extends StatelessWidget {
  const TherapistAppointmentsScreen({super.key});

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.calendarXmark,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyTextSecondary.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingList(
    List<AppointmentModel> sessions,
    AppointmentController controller,
  ) {
    if (sessions.isEmpty) {
      return _buildEmptyState(
        'No pending requests yet.\nPatients\' requests will appear here.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return RoleBasedSessionCard(
          appointment: session,
          role: 'therapist',
          onAccept: () => controller.acceptAppointment(session.id),
          onReject: () => controller.rejectAppointment(session.id),
        );
      },
    );
  }

  Widget _buildUpcomingList(
    List<AppointmentModel> sessions,
    AppointmentController controller,
  ) {
    if (sessions.isEmpty) {
      return _buildEmptyState('No upcoming sessions scheduled.');
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        final now = DateTime.now();
        final canStart =
            session.startedAt == null && now.isAfter(session.date.toDate());
        return RoleBasedSessionCard(
          appointment: session,
          role: 'therapist',
          onStart: canStart ? () => controller.startSession(session.id) : null,
          onComplete: () => controller.completeAppointment(session.id),
          onCancel: () => controller.cancelAppointment(session.id),
        );
      },
    );
  }

  Widget _buildCompletedList(List<AppointmentModel> sessions) {
    if (sessions.isEmpty) return _buildEmptyState('No completed sessions yet.');
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        return RoleBasedSessionCard(
          appointment: sessions[index],
          role: 'therapist',
        );
      },
    );
  }

  Widget _buildCancelledList(List<AppointmentModel> sessions) {
    if (sessions.isEmpty) return _buildEmptyState('No cancelled sessions.');
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        return RoleBasedSessionCard(
          appointment: sessions[index],
          role: 'therapist',
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
        appBar: const TherapistAppBar(title: 'Appointments Dashboard'),
        body: Column(
          children: [
            Container(
              color: AppColors.background,
              child: TabBar(
                isScrollable: true,
                padding: EdgeInsets.zero,
                labelColor: const Color(0xFF6246EA),
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: const Color(0xFF6246EA),
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Requests'),
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Cancelled'),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                return TabBarView(
                  children: [
                    _buildPendingList(
                      controller.therapistPendingAppointments.toList(),
                      controller,
                    ),
                    _buildUpcomingList(
                      controller.therapistUpcomingAppointments.toList(),
                      controller,
                    ),
                    _buildCompletedList(
                      controller.therapistCompletedAppointments.toList(),
                    ),
                    _buildCancelledList(
                      controller.therapistCancelledAppointments.toList(),
                    ),
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
