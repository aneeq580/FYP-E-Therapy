import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';

/// Reusable widget for session card
class SessionCard extends StatelessWidget {
  final String date;
  final String time;
  final String therapistName;
  final String status; // e.g., "Upcoming", "Completed", "Cancelled"
  final VoidCallback? onTap;

  const SessionCard({
    super.key,
    required this.date,
    required this.time,
    required this.therapistName,
    required this.status,
    this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return AppColors.accent;
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return AppColors.accent.withOpacity(0.1);
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
    final statusColor = _getStatusColor(status);
    final statusBgColor = _getStatusBackgroundColor(status);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMedium,
        vertical: AppSizes.spacingSmall,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.success.withOpacity(0.6), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacingMedium),
          child: Row(
            children: [
              // Date/Time Column
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      date.split(' ')[0], // Day name or day number
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date.split(' ').length > 1
                          ? date.split(' ')[1]
                          : date, // Month or date
                      style: AppTextStyles.bodyTextSecondary.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.spacingMedium),

              // Therapist and Status Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      therapistName,
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
                            status,
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

              // Chevron Icon
              Icon(Icons.chevron_right, color: AppColors.textLight, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
