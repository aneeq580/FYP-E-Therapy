import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';
import '../../models/appointment_model.dart';
import 'package:intl/intl.dart';

/// Reusable widget for session card with Role-Based aesthetics
class RoleBasedSessionCard extends StatelessWidget {
  final AppointmentModel appointment;
  final String role; // 'patient' or 'therapist'
  final VoidCallback? onTap;

  // Therapist Only Actions
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onComplete;
  final VoidCallback? onCancel;

  const RoleBasedSessionCard({
    super.key,
    required this.appointment,
    required this.role,
    this.onTap,
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

  // Common status color base
  Color _getStatusColor(String status, bool isPatient) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning; // orange
      case 'approved':
      case 'upcoming':
        return Colors.yellow.shade700; // yellow
      case 'completed':
        return isPatient
            ? const Color(0xFF4CAF50)
            : const Color(
                0xFF6246EA,
              ); // Green for patient, Purple for therapist
      case 'cancelled':
        return AppColors.error; // red
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPatient = role.toLowerCase() == 'patient';

    // Core Role Colors
    final primaryAccent = isPatient
        ? const Color(0xFF4CAF50)
        : const Color(0xFF6246EA); // Purple for therapist
    final bgColor = isPatient
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFF3E5F5); // Light purple for therapist

    final statusColor = _getStatusColor(appointment.status, isPatient);
    final statusBgColor = statusColor.withOpacity(0.1);
    final displayStatus = appointment.status.toLowerCase() == 'approved'
        ? 'Upcoming'
        : appointment.status[0].toUpperCase() + appointment.status.substring(1);

    final String displayName = isPatient
        ? appointment.therapistName
        : appointment.patientName;

    return Card(
      color: bgColor,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMedium,
        vertical: AppSizes.spacingSmall,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: primaryAccent.withOpacity(0.5), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
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
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatDate().split(' ')[0],
                          style: AppTextStyles.bodyText.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: primaryAccent,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate().split(' ').length > 1
                              ? _formatDate().split(' ')[1]
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
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacingMedium),

                  // Name and Status Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
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
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (onTap != null)
                    FaIcon(
                      FontAwesomeIcons.chevronRight,
                      color: primaryAccent.withOpacity(0.7),
                      size: 20,
                    ),
                ],
              ),

              // Therapist Action Buttons Section
              if (!isPatient &&
                  (onAccept != null ||
                      onReject != null ||
                      onComplete != null ||
                      onCancel != null))
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.textSecondary.withOpacity(0.15),
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
                              color: Colors.white,
                            ),
                            label: Text(
                              onAccept != null ? 'Accept' : 'Complete',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryAccent,
                              foregroundColor: Colors.white,
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
      ),
    );
  }
}
