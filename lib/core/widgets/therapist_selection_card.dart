import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';

/// Reusable widget for therapist selection card
class TherapistSelectionCard extends StatelessWidget {
  final String? selectedTherapist;
  final String? selectedTherapistSpecialty;
  final String? profileImageUrl;
  final VoidCallback? onTap;

  const TherapistSelectionCard({
    super.key,
    this.selectedTherapist,
    this.selectedTherapistSpecialty,
    this.profileImageUrl,
    this.onTap,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacingMedium),
            child: Row(
              children: [
                // Therapist Profile Image or Icon
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.iconTherapists.withOpacity(0.1),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: profileImageUrl != null
                        ? Image.network(
                            profileImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: FaIcon(
                                  FontAwesomeIcons.userDoctor,
                                  color: AppColors.iconTherapists,
                                  size: 28,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: FaIcon(
                              FontAwesomeIcons.userDoctor,
                              color: AppColors.iconTherapists,
                              size: 32,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: AppSizes.spacingMedium),

                // Therapist Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedTherapist ?? 'Select Therapist',
                        style: AppTextStyles.bodyText.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: selectedTherapist != null
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
                      ] else if (selectedTherapist == null) ...[
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
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: AppColors.textLight,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
