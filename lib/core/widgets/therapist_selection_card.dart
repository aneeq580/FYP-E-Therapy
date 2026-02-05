import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';

/// Reusable widget for therapist selection card
class TherapistSelectionCard extends StatelessWidget {
  final String? selectedTherapistName;
  final String? selectedTherapistSpecialty;
  final VoidCallback? onTap;

  const TherapistSelectionCard({
    super.key,
    this.selectedTherapistName,
    this.selectedTherapistSpecialty,
    this.onTap,
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacingMedium),
          child: Row(
            children: [
              // Therapist Icon/Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.iconTherapists.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FontAwesomeIcons.userDoctor,
                  color: AppColors.iconTherapists,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSizes.spacingMedium),

              // Therapist Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedTherapistName ?? 'Select Therapist',
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: selectedTherapistName != null
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    if (selectedTherapistSpecialty != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        selectedTherapistSpecialty!,
                        style: AppTextStyles.bodyTextSecondary.copyWith(
                          fontSize: 13,
                        ),
                      ),
                    ] else if (selectedTherapistName == null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Choose a therapist for your session',
                        style: AppTextStyles.bodyTextSecondary.copyWith(
                          fontSize: 13,
                        ),
                      ),
                    ],
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
