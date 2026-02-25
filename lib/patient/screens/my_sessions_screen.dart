import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/patient_app_bar.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/session_card.dart';
import '../../controllers/session_controller.dart';
import '../../models/session_model.dart';

/// My Sessions Screen - Patient view with 4 status tabs.
class MySessionsScreen extends GetView<SessionController> {
  const MySessionsScreen({super.key});

  String _formatDate(SessionModel session) {
    final dt = session.sessionDateTime;
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekday = weekdays[dt.weekday - 1];
    final day = dt.day.toString().padLeft(2, '0');
    return '$weekday $day';
  }

  String _formatTime(SessionModel session) {
    final dt = session.sessionDateTime;
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

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

  Widget _buildSessionList(RxList<SessionModel> sessions) {
    return Obx(() {
      final items = sessions;
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
          return SessionCard(
            date: _formatDate(session),
            time: _formatTime(session),
            therapistName: session.therapistName,
            status: session.status.capitalizeFirst ?? session.status,
            onTap: () {
              // TODO: Navigate to session details screen when implemented.
            },
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
              child: TabBarView(
                children: [
                  _buildSessionList(controller.getPendingSessions()),
                  _buildSessionList(controller.getUpcomingSessions()),
                  _buildSessionList(controller.getCompletedSessions()),
                  _buildSessionList(controller.getCancelledSessions()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
