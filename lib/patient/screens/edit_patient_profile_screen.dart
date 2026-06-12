import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/core/constants/colors.dart';
import 'package:fyp_therapy/core/constants/styles.dart';
import '../profile/patient_profile_controller.dart';

class EditPatientProfileScreen extends StatefulWidget {
  const EditPatientProfileScreen({super.key});

  @override
  State<EditPatientProfileScreen> createState() =>
      _EditPatientProfileScreenState();
}

class _EditPatientProfileScreenState extends State<EditPatientProfileScreen> {
  final PatientProfileController controller =
      Get.find<PatientProfileController>();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController ageController;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: controller.fullName.value);
    emailController = TextEditingController(text: controller.email.value);
    ageController = TextEditingController(
      text: controller.age.value != null ? '${controller.age.value}' : '',
    );

    final normalizedGender = _normalizeGender(controller.gender.value);
    selectedGender = normalizedGender.isEmpty ? null : normalizedGender;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    super.dispose();
  }

  String _normalizeGender(String raw) {
    final value = raw.trim().toLowerCase();
    if (value.isEmpty) return '';
    if (value == 'male' || value == 'm') return 'Male';
    if (value == 'female' || value == 'f') return 'Female';
    return 'Prefer not to say';
  }

  void _saveProfile() async {
    final parsedAge = int.tryParse(ageController.text);
    await controller.saveProfileEdits(
      newFullName: nameController.text,
      newEmail: emailController.text,
      newAge: parsedAge,
      newGender: selectedGender ?? '',
      newProfileImageUrl: controller.profileImageUrl.value,
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              if (!controller.isLoading.value) {
                _saveProfile();
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Basic Information'),
              const SizedBox(height: AppSizes.spacingSmall),
              _buildTextField(
                controller: nameController,
                label: 'Full Name',
                icon: Icons.person,
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              _buildTextField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSizes.spacingLarge),

              _buildSectionTitle('Personal Details'),
              const SizedBox(height: AppSizes.spacingSmall),
              _buildTextField(
                controller: ageController,
                label: 'Age',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: const Icon(
                      Icons.people,
                      color: AppColors.iconSettings,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
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
              ),
              const SizedBox(height: AppSizes.spacingLarge * 2),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (!controller.isLoading.value) {
                      _saveProfile();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.iconSettings),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
