import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';

/// Reusable widget for date and time selection card
class DateTimeSelectionCard extends StatelessWidget {
  final String? selectedDate;
  final String? selectedTime;
  final VoidCallback? onDateTap;
  final VoidCallback? onTimeTap;

  const DateTimeSelectionCard({
    super.key,
    this.selectedDate,
    this.selectedTime,
    this.onDateTap,
    this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.textLight.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Date & Time',
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppSizes.spacingMedium),

            // Date Selection Row
            InkWell(
              onTap: onDateTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(AppSizes.spacingMedium),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppSizes.spacingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: AppTextStyles.bodyTextSecondary.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            selectedDate ?? 'Select date',
                            style: AppTextStyles.bodyText.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: selectedDate != null
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.textLight,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSizes.spacingMedium),

            // Time Selection Row
            InkWell(
              onTap: onTimeTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(AppSizes.spacingMedium),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppSizes.spacingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time',
                            style: AppTextStyles.bodyTextSecondary.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            selectedTime ?? 'Select time',
                            style: AppTextStyles.bodyText.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: selectedTime != null
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.textLight,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
