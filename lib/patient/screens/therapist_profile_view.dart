import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../routes/app_routes.dart';

class TherapistProfileView extends StatelessWidget {
  final Map<String, dynamic> therapist;

  const TherapistProfileView({super.key, required this.therapist});

  @override
  Widget build(BuildContext context) {
    final String name = therapist['fullName'] as String? ?? 'Therapist';
    final String specialty =
        therapist['specialty'] as String? ?? 'General Therapist';
    final String bio = therapist['bio'] as String? ?? 'No bio available.';
    final String education =
        therapist['education'] as String? ?? 'Not specified';
    final double rating = (therapist['rating'] as num?)?.toDouble() ?? 5.0;
    final int experience = (therapist['experience'] as num?)?.toInt() ?? 0;
    final double hourlyRate =
        (therapist['hourlyRate'] as num?)?.toDouble() ?? 0.0;
    final String? profileImageUrl =
        therapist['profileImageUrl'] as String? ??
        therapist['photoUrl'] as String?;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Premium Header with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    size: 18,
                    color: Colors.white,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _buildProfileImage(profileImageUrl),
                  // Gradient overlay for text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          specialty,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem(
                        FontAwesomeIcons.briefcase,
                        '$experience yrs+',
                        'Experience',
                        const Color(0xFFE3F2FD),
                        const Color(0xFF1976D2),
                      ),
                      _buildStatItem(
                        FontAwesomeIcons.solidStar,
                        rating.toStringAsFixed(1),
                        'Rating',
                        const Color(0xFFFFF8E1),
                        const Color(0xFFFFA000),
                      ),
                      _buildStatItem(
                        FontAwesomeIcons.dollarSign,
                        '\$${hourlyRate.toStringAsFixed(0)}',
                        'Rate/hr',
                        const Color(0xFFE8F5E9),
                        const Color(0xFF388E3C),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // About Section
                  _buildSectionTitle(
                    'About Therapist',
                    FontAwesomeIcons.circleInfo,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    bio,
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.textPrimary.withOpacity(0.7),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Education Section
                  _buildSectionTitle(
                    'Education & Expertise',
                    FontAwesomeIcons.graduationCap,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[100]!),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.certificate,
                          size: 20,
                          color: AppColors.iconBookSession,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Academic Background',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                education,
                                style: TextStyle(
                                  color: AppColors.textPrimary.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // Navigate to booking flow
            Get.toNamed(AppRoutes.bookSession, arguments: therapist);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.calendarCheck, size: 18),
              SizedBox(width: 12),
              Text(
                'Book Appointment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Renders the profile image, supporting both asset paths and network URLs.
  Widget _buildProfileImage(String? url) {
    if (url == null || url.isEmpty) {
      return Container(
        color: AppColors.primary.withOpacity(0.1),
        child: const Center(
          child: FaIcon(
            FontAwesomeIcons.userDoctor,
            size: 80,
            color: AppColors.iconTherapists,
          ),
        ),
      );
    }

    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.primary.withOpacity(0.1),
          child: const Center(
            child: FaIcon(
              FontAwesomeIcons.userDoctor,
              size: 80,
              color: AppColors.iconTherapists,
            ),
          ),
        ),
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: AppColors.primary.withOpacity(0.05),
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        color: AppColors.primary.withOpacity(0.1),
        child: const Center(
          child: FaIcon(
            FontAwesomeIcons.userDoctor,
            size: 80,
            color: AppColors.iconTherapists,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: FaIcon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textPrimary.withOpacity(0.5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        FaIcon(icon, size: 18, color: AppColors.iconSettings),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
