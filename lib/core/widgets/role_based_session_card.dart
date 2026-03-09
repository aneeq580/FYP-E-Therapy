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
  final VoidCallback? onStart;
  // When true, the Start button renders at reduced opacity (session time not yet reached)
  final bool isStartDisabled;

  // Patient Only Action
  final VoidCallback? onJoin; // triggered when patient clicks "Join Chat"

  const RoleBasedSessionCard({
    super.key,
    required this.appointment,
    required this.role,
    this.onTap,
    this.onAccept,
    this.onReject,
    this.onComplete,
    this.onCancel,
    this.onStart,
    this.isStartDisabled = false,
    this.onJoin,
  });

  String _formatDate() {
    final dt = appointment.date.toDate();
    return DateFormat('E dd').format(dt);
  }

  String _formatTime() {
    final dt = appointment.date.toDate();
    return DateFormat('h:mm a').format(dt);
  }

  Color _getStatusColor(String status, bool isPatient) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'approved':
      case 'upcoming':
        return Colors.yellow.shade700;
      case 'ongoing':
      case 'active':
      case 'started':
        return AppColors.iconBookSession; // Deep Blue for better contrast
      case 'completed':
        return isPatient
            ? const Color(0xFF2E7D32)
            : AppColors
                  .iconBookSession; // Darker theme-consistent green or secondary
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  bool get _isSessionActive {
    final s = appointment.status.toLowerCase();
    return s == 'ongoing' || s == 'active' || s == 'started';
  }

  @override
  Widget build(BuildContext context) {
    final isPatient = role.toLowerCase() == 'patient';

    // Core Role Colors — Patient uses Turquoise theme
    final primaryAccent = isPatient
        ? AppColors.primary
        : const Color(0xFF6246EA);
    final bgColor = isPatient
        ? AppColors.backgroundLight
        : const Color(0xFFF3E5F5);

    final statusColor = _getStatusColor(appointment.status, isPatient);
    final statusBgColor = statusColor.withOpacity(0.1);
    final displayStatus = appointment.status.toLowerCase() == 'approved'
        ? 'Upcoming'
        : appointment.status.toLowerCase() == 'completed'
        ? 'Session Ended'
        : (appointment.status.toLowerCase() == 'ongoing' ||
              appointment.status.toLowerCase() == 'started' ||
              appointment.status.toLowerCase() == 'active')
        ? 'Ongoing'
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
        side: BorderSide(
          color: _isSessionActive && isPatient
              ? AppColors.primary
              : primaryAccent.withOpacity(0.3),
          width: _isSessionActive && isPatient ? 2 : 1,
        ),
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
                        if (appointment.duration > 0) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${appointment.duration} min • ends ${DateFormat('h:mm a').format(appointment.endTime.toDate())}',
                            style: AppTextStyles.bodyTextSecondary.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
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

              // ── Patient Join Chat Button ──────────────────────────────
              if (isPatient && onJoin != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSessionActive ? onJoin : null,
                    icon: FaIcon(
                      FontAwesomeIcons.commentDots,
                      size: 16,
                      color: _isSessionActive
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                    label: Text(
                      _isSessionActive ? 'Join Chat' : 'Waiting for therapist…',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSessionActive
                          ? AppColors.primary
                          : AppColors.backgroundLight,
                      foregroundColor: _isSessionActive
                          ? Colors.white
                          : AppColors.textSecondary,
                      disabledBackgroundColor: AppColors.backgroundLight,
                      disabledForegroundColor: AppColors.textSecondary,
                      elevation: _isSessionActive ? 2 : 0,
                      shadowColor: AppColors.primary.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: _isSessionActive
                              ? AppColors.primary
                              : AppColors.textLight.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],

              // ── Therapist Action Buttons Section ─────────────────────
              if (!isPatient &&
                  (onAccept != null ||
                      onReject != null ||
                      onComplete != null ||
                      onCancel != null ||
                      onStart != null))
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
                          (onStart != null ||
                              onAccept != null ||
                              onComplete != null))
                        const SizedBox(width: 12),
                      if (onStart != null || isStartDisabled)
                        Expanded(
                          child: Opacity(
                            opacity: isStartDisabled ? 0.4 : 1.0,
                            child: ElevatedButton(
                              onPressed: isStartDisabled ? null : onStart,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                              child: const Text('Start'),
                            ),
                          ),
                        ),
                      if (onStart != null &&
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
