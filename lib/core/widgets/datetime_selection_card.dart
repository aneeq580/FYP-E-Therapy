import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';

/// Reusable widget for date and time selection card
class DateTimeSelectionCard extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textLight.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
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
            Material(
              color: Colors.transparent,
              child: InkWell(
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
                      FaIcon(
                        FontAwesomeIcons.calendar,
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
                              selectedDate != null
                                  ? '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}'
                                  : 'Select date',
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
                      FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: AppColors.textLight,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSizes.spacingMedium),

            // Time Selection Row
            Material(
              color: Colors.transparent,
              child: InkWell(
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
                      FaIcon(
                        FontAwesomeIcons.clock,
                        color: AppColors.secondary,
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
                              selectedTime != null
                                  ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                                  : 'Select time',
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
                      FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: AppColors.textLight,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
