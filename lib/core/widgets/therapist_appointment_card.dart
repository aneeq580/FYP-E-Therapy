import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';
import '../../../models/appointment_model.dart';
import 'package:intl/intl.dart';

class TherapistAppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  // Dynamic action buttons
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onComplete;
  final VoidCallback? onCancel;

  const TherapistAppointmentCard({
    super.key,
    required this.appointment,
    this.onAccept,
    this.onReject,
    this.onComplete,
    this.onCancel,
  });

  String _formatDate() {
    final dt = appointment.date.toDate();
    return DateFormat('E dd').format(dt);
  }

  String _formatTime() {
    final dt = appointment.date.toDate();
    return DateFormat('h:mm a').format(dt);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning; // orange
      case 'approved':
      case 'upcoming':
        return Colors.yellow.shade700; // yellow
      case 'completed':
        return AppColors.success; // green
      case 'cancelled':
        return AppColors.error; // red
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning.withOpacity(0.1);
      case 'approved':
      case 'upcoming':
        return Colors.yellow.shade700.withOpacity(0.1);
      case 'completed':
        return AppColors.success.withOpacity(0.1);
      case 'cancelled':
        return AppColors.error.withOpacity(0.1);
      default:
        return AppColors.textSecondary.withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(appointment.status);
    final statusBgColor = _getStatusBgColor(appointment.status);
    final displayStatus = appointment.status.toLowerCase() == 'approved'
        ? 'Upcoming'
        : appointment.status[0].toUpperCase() + appointment.status.substring(1);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMedium,
        vertical: AppSizes.spacingSmall,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingMedium),
        child: Column(
          children: [
            Row(
              children: [
                // Date/Time Column
                Container(
                  width: 70,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatDate().split(' ')[0], // Mon
                        style: AppTextStyles.bodyText.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate().split(' ').length > 1
                            ? _formatDate().split(' ')[1] // 05
                            : '',
                        style: AppTextStyles.bodyTextSecondary.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(),
                        style: AppTextStyles.bodyText.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.spacingMedium),

                // Patient and Status Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patientName,
                        style: AppTextStyles.bodyText.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              displayStatus,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Action Buttons Section
            if (onAccept != null ||
                onReject != null ||
                onComplete != null ||
                onCancel != null)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.textSecondary.withOpacity(0.2),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (onReject != null || onCancel != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onReject ?? onCancel,
                          icon: FaIcon(
                            FontAwesomeIcons.xmark,
                            size: 16,
                            color: AppColors.error,
                          ),
                          label: Text(onReject != null ? 'Reject' : 'Cancel'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: BorderSide(color: AppColors.error),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    if ((onReject != null || onCancel != null) &&
                        (onAccept != null || onComplete != null))
                      const SizedBox(width: 12),
                    if (onAccept != null || onComplete != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onAccept ?? onComplete,
                          icon: FaIcon(
                            onAccept != null
                                ? FontAwesomeIcons.check
                                : FontAwesomeIcons.flagCheckered,
                            size: 16,
                            color: AppColors.textOnPrimary,
                          ),
                          label: Text(onAccept != null ? 'Accept' : 'Complete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textOnPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
