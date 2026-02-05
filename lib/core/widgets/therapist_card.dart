import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';

/// Reusable widget for therapist profile card
class TherapistCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final String? photoUrl;
  final VoidCallback? onViewProfile;

  const TherapistCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    this.photoUrl,
    this.onViewProfile,
  });

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: AppColors.secondary, size: 16);
        } else if (index < rating) {
          return const Icon(
            Icons.star_half,
            color: AppColors.secondary,
            size: 16,
          );
        } else {
          return Icon(
            Icons.star_border,
            color: AppColors.secondary.withOpacity(0.3),
            size: 16,
          );
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMedium,
        vertical: AppSizes.spacingSmall,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.accent, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Therapist Photo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.iconTherapists.withOpacity(0.1),
                    border: Border.all(
                      color: AppColors.iconTherapists.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: photoUrl != null
                        ? Image.network(
                            photoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                FontAwesomeIcons.userDoctor,
                                color: AppColors.iconTherapists,
                                size: 40,
                              );
                            },
                          )
                        : Icon(
                            FontAwesomeIcons.userDoctor,
                            color: AppColors.iconTherapists,
                            size: 40,
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
                        name,
                        style: AppTextStyles.bodyText.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        specialty,
                        style: AppTextStyles.bodyTextSecondary.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildRatingStars(rating),
                          const SizedBox(width: 6),
                          Text(
                            rating.toStringAsFixed(1),
                            style: AppTextStyles.bodyTextSecondary.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.spacingMedium),

            // View Profile Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onViewProfile,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'View Profile',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
