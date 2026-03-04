import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/auth_controller.dart';
import 'package:fyp_therapy/patient/profile/patient_profile_controller.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/patient_app_bar.dart';
import 'profile_header.dart';
import 'activity_card.dart';
import 'settings_tile.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is available for this screen.
    final controller = Get.put(PatientProfileController());

    // check if this screen was opened immediately after signup and
    // requires the user to complete their profile.  the sign-up flow
    // passes an argument `requireCompletion: true` when navigating here.
    final args = Get.arguments as Map<String, dynamic>?;
    final requireCompletion = args != null && args['requireCompletion'] == true;

    // if profile completion is forced we show the edit dialog as soon
    // as the screen is rendered.  using a post-frame callback ensures
    // the context is ready when the dialog is pushed.
    if (requireCompletion && !controller.hasShownCompletionPrompt.value) {
      // ensure we only show it once even if the widget rebuilds
      controller.hasShownCompletionPrompt.value = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showEditProfileDialog(
          context,
          controller,
          requireCompletion: requireCompletion,
        );
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => ProfileHeader(
                displayName: controller.displayName,
                subtitle: controller.displayEmail,
                profileImageUrl: controller.profileImageUrl.value.isEmpty
                    ? null
                    : controller.profileImageUrl.value,
                onEditTap: () => _showEditProfileDialog(
                  context,
                  controller,
                  requireCompletion: requireCompletion,
                ),
              ),
            ),

            const SizedBox(height: AppSizes.spacingLarge),

            // Account Information
            Obx(
              () => Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingMedium,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.spacingMedium),
                      child: Text(
                        'Account Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    _buildInfoRow(
                      FontAwesomeIcons.cake,
                      'Age',
                      controller.age.value != null
                          ? '${controller.age.value} years'
                          : 'Not set',
                    ),
                    const Divider(height: 1, indent: 50),
                    _buildInfoRow(
                      FontAwesomeIcons.user,
                      'Gender',
                      controller.gender.value.isEmpty
                          ? 'Not set'
                          : controller.gender.value,
                    ),
                    const Divider(height: 1, indent: 50),
                    _buildInfoRow(
                      FontAwesomeIcons.calendar,
                      'Joined',
                      controller.formattedJoinedDate,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSizes.spacingLarge),

            // Therapy Activity
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppSizes.spacingMedium,
                      bottom: AppSizes.spacingMedium,
                    ),
                    child: Text(
                      'Therapy Activity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ActivityCard(
                          icon: FontAwesomeIcons.calendarCheck,
                          title: 'Sessions',
                          value: '12',
                          subtitle: 'Completed',
                          color: AppColors.iconMySessions,
                          backgroundColor: AppColors.iconBgMySessions,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spacingMedium),
                      Expanded(
                        child: ActivityCard(
                          icon: FontAwesomeIcons.clock,
                          title: 'Upcoming',
                          value: '2',
                          subtitle: 'This week',
                          color: AppColors.iconBookSession,
                          backgroundColor: AppColors.iconBgBookSession,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacingMedium),
                  ActivityCard(
                    icon: FontAwesomeIcons.faceSmile,
                    title: 'Mood Check-ins',
                    value: '45',
                    subtitle: 'Total entries',
                    color: AppColors.iconMoodTracker,
                    backgroundColor: AppColors.iconBgMoodTracker,
                    isFullWidth: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spacingLarge),

            // Settings
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingMedium,
              ),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.spacingMedium),
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    icon: FontAwesomeIcons.bell,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 50),
                  SettingsTile(
                    icon: FontAwesomeIcons.lock,
                    title: 'Privacy & Security',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 50),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.moon,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      'Dark Mode',
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Switch(
                      value: false,
                      onChanged: (v) {},
                      thumbColor: WidgetStateProperty.all(AppColors.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spacingMedium,
                      vertical: 4,
                    ),
                  ),
                  const Divider(height: 1, indent: 50),
                  SettingsTile(
                    icon: FontAwesomeIcons.language,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 50),
                  SettingsTile(
                    icon: FontAwesomeIcons.circleQuestion,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spacingLarge),

            // Logout
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingMedium,
              ),
              child: Column(
                children: [
                  Container(
                    height: 1,
                    color: AppColors.textLight.withOpacity(0.3),
                    margin: const EdgeInsets.only(
                      bottom: AppSizes.spacingLarge,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.find<AuthController>().handleLogout();
                      },
                      icon: const FaIcon(FontAwesomeIcons.rightFromBracket),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spacingLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMedium,
        vertical: AppSizes.spacingMedium,
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppSizes.spacingMedium),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(value, style: AppTextStyles.bodyTextSecondary),
        ],
      ),
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    PatientProfileController controller, {
    bool requireCompletion = false,
  }) {
    final nameController = TextEditingController(
      text: controller.fullName.value,
    );
    final emailController = TextEditingController(text: controller.email.value);
    final ageController = TextEditingController(
      text: controller.age.value != null ? '${controller.age.value}' : '',
    );
    // Normalize gender into one of the allowed options if possible.
    final normalizedGender = _normalizeGender(controller.gender.value);
    final joinedController = TextEditingController(
      text: controller.formattedJoinedDate == 'Not set'
          ? ''
          : controller.formattedJoinedDate,
    );
    final imageUrlController = TextEditingController(
      text: controller.profileImageUrl.value,
    );

    DateTime? selectedJoinedAt = controller.joinedAt.value;

    String? selectedGender = normalizedGender.isEmpty ? null : normalizedGender;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Profile'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: ageController,
                      decoration: const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: const InputDecoration(labelText: 'Gender'),
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(
                          value: 'Female',
                          child: Text('Female'),
                        ),
                        DropdownMenuItem(
                          value: 'Prefer not to say',
                          child: Text('Prefer not to say'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final now = DateTime.now();
                        final initialDate = selectedJoinedAt ?? now;
                        final picked = await showDatePicker(
                          context: dialogContext,
                          initialDate: initialDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(now.year + 1),
                        );
                        if (picked != null) {
                          selectedJoinedAt = picked;
                          joinedController.text =
                              '${picked.day}/${picked.month}/${picked.year}';
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: joinedController,
                          decoration: const InputDecoration(
                            labelText: 'Joined date',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Profile image URL',
                        hintText: 'https://...',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                Obx(
                  () => TextButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            final parsedAge = int.tryParse(ageController.text);
                            await controller.saveProfileEdits(
                              newFullName: nameController.text,
                              newEmail: emailController.text,
                              newAge: parsedAge,
                              newGender: selectedGender ?? '',
                              newJoinedAt: selectedJoinedAt,
                              newProfileImageUrl: imageUrlController.text,
                            );
                            Get.back();

                            // if this profile dialog was shown as part of the
                            // initial signup flow we now redirect to the
                            // patient's home screen so the user lands on the
                            // dashboard rather than remaining on the profile
                            // page.
                            if (requireCompletion) {
                              Get.offAllNamed(AppRoutes.patientHome);
                            }
                          },
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Map any stored gender string into one of the three allowed options.
  String _normalizeGender(String raw) {
    final value = raw.trim().toLowerCase();
    if (value.isEmpty) return '';
    if (value == 'male' || value == 'm') return 'Male';
    if (value == 'female' || value == 'f') return 'Female';
    return 'Prefer not to say';
  }
}
