import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../controllers/therapist_profile_controller.dart';

class TherapistProfileScreen extends GetView<TherapistProfileController> {
  const TherapistProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.therapistBackground,
      body: Obx(() {
        if (controller.isLoading.value && controller.profileData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsRow(),
                    const SizedBox(height: AppSizes.spacingLarge),
                    _buildVerificationStatusCard(),
                    const SizedBox(height: AppSizes.spacingLarge),
                    _buildSectionTitle('About Me'),
                    const SizedBox(height: AppSizes.spacingSmall),
                    _buildBio(),
                    const SizedBox(height: AppSizes.spacingLarge),
                    _buildSectionTitle('Professional Information'),
                    const SizedBox(height: AppSizes.spacingSmall),
                    _buildInfoCard([
                      _buildInfoTile(
                        icon: FontAwesomeIcons.userGraduate,
                        label: 'Education',
                        value: controller.education.value.isEmpty
                            ? 'Not specified'
                            : controller.education.value,
                      ),
                      _buildInfoTile(
                        icon: FontAwesomeIcons.briefcase,
                        label: 'Experience',
                        value: '${controller.experience.value} Years',
                      ),
                      _buildInfoTile(
                        icon: FontAwesomeIcons.stethoscope,
                        label: 'Specialty',
                        value: controller.specialty.value,
                      ),
                    ]),
                    const SizedBox(height: AppSizes.spacingLarge),
                    _buildSectionTitle('Contact Information'),
                    const SizedBox(height: AppSizes.spacingSmall),
                    _buildInfoCard([
                      _buildInfoTile(
                        icon: FontAwesomeIcons.envelope,
                        label: 'Email',
                        value: controller.profileData['email'] ?? 'N/A',
                      ),
                      _buildInfoTile(
                        icon: FontAwesomeIcons.phone,
                        label: 'Phone',
                        value: controller.phone.value.isEmpty
                            ? 'Not specified'
                            : controller.phone.value,
                      ),
                    ]),
                    const SizedBox(height: AppSizes.spacingLarge),
                    _buildHourlyRate(),
                    const SizedBox(height: AppSizes.spacingLarge * 2),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(AppRoutes.editTherapistProfile);
        },
        label: const Text('Edit Profile'),
        icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 18),
        backgroundColor: AppColors.therapistPrimary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.therapistPrimary,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.therapistPrimary,
                    AppColors.therapistSecondary,
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                _buildProfileImage(),
                const SizedBox(height: AppSizes.spacingMedium),
                Text(
                  controller.fullName.value,
                  style: AppTextStyles.headerTitle.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.specialty.value,
                  style: AppTextStyles.headerSubtitle.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                _buildRatingBadge(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipOval(
        child: controller.profileImageUrl.value.isNotEmpty
            ? Image.network(
                controller.profileImageUrl.value,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildInitialsAvatar(),
              )
            : _buildInitialsAvatar(),
      ),
    );
  }

  Widget _buildInitialsAvatar() {
    final name = controller.fullName.value;
    String initials = '';
    if (name.isNotEmpty) {
      final parts = name.split(' ');
      if (parts.length > 1) {
        initials = (parts[0][0] + parts[1][0]).toUpperCase();
      } else {
        initials = parts[0][0].toUpperCase();
      }
    }

    return Container(
      color: AppColors.therapistSecondary,
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
          const SizedBox(width: 4),
          Text(
            controller.rating.value.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItem('Sessions', '120+', FontAwesomeIcons.calendarCheck),
        _buildStatItem('Experience', '${controller.experience.value}Y', FontAwesomeIcons.clock),
        _buildStatItem('Rating', controller.rating.value.toStringAsFixed(1), FontAwesomeIcons.star),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.therapistSurface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            FaIcon(icon, color: AppColors.therapistPrimary, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.bodyTextSecondary.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildBio() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.therapistSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        controller.bio.value.isEmpty
            ? 'No bio provided. Share a bit about your professional background and approach to therapy.'
            : controller.bio.value,
        style: AppTextStyles.bodyText.copyWith(height: 1.5),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.therapistSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMedium,
        vertical: AppSizes.spacingMedium,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.therapistPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FaIcon(icon, size: 18, color: AppColors.therapistPrimary),
          ),
          const SizedBox(width: AppSizes.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodyTextSecondary.copyWith(fontSize: 12),
                ),
                Text(
                  value,
                  style: AppTextStyles.bodyText.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyRate() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.therapistPrimary,
            AppColors.therapistSecondary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Consultation Rate',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '\$${controller.hourlyRate.value.toStringAsFixed(0)} / Session',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationStatusCard() {
    final status = controller.profileData['verificationStatus'] ?? 'none';
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case 'approved':
        color = Colors.green;
        text = "Verified Account";
        icon = FontAwesomeIcons.circleCheck;
        break;
      case 'pending':
        color = Colors.orange;
        text = "Verification Pending";
        icon = FontAwesomeIcons.clock;
        break;
      case 'rejected':
        color = Colors.red;
        text = "Verification Rejected";
        icon = FontAwesomeIcons.circleExclamation;
        break;
      default:
        color = AppColors.therapistPrimary;
        text = "Account Not Verified";
        icon = FontAwesomeIcons.shieldHalved;
    }

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.therapistVerification),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            FaIcon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    status == 'approved'
                        ? "Your account is verified."
                        : status == 'pending'
                            ? "Document is under review."
                            : "Click here to upload degree certificate.",
                    style: TextStyle(
                      color: color.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }
}
