import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/core/constants/colors.dart';
import 'package:fyp_therapy/core/constants/styles.dart';
import '../controllers/therapist_profile_controller.dart';

class EditTherapistProfileScreen extends GetView<TherapistProfileController> {
  const EditTherapistProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.therapistBackground,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.therapistPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => controller.updateProfile(),
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
                controller: controller.nameController,
                label: 'Full Name',
                icon: Icons.person,
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              _buildTextField(
                controller: controller.phoneController,
                label: 'Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSizes.spacingLarge),

              _buildSectionTitle('Professional Details'),
              const SizedBox(height: AppSizes.spacingSmall),
              _buildSpecialtiesSection(context),
              const SizedBox(height: AppSizes.spacingMedium),
              _buildTextField(
                controller: controller.educationController,
                label: 'Education',
                icon: Icons.school,
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: controller.experienceController,
                      label: 'Experience (Years)',
                      icon: Icons.work,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacingMedium),
                  Expanded(
                    child: _buildTextField(
                      controller: controller.hourlyRateController,
                      label: 'Rate (\$/Session)',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spacingLarge),

              _buildSectionTitle('About Me'),
              const SizedBox(height: AppSizes.spacingSmall),
              _buildTextField(
                controller: controller.bioController,
                label: 'Bio',
                icon: Icons.description,
                maxLines: 5,
              ),
              const SizedBox(height: AppSizes.spacingLarge * 2),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.updateProfile(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.therapistPrimary,
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
        color: AppColors.therapistSecondary,
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
          prefixIcon: Icon(icon, color: AppColors.therapistPrimary),
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

  Widget _buildSpecialtiesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacingMedium),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.medical_services,
                color: AppColors.therapistPrimary,
              ),
              const SizedBox(width: AppSizes.spacingSmall),
              const Text(
                'Specialties',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingMedium),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...controller.specialtiesList.map(
                  (spec) => Chip(
                    label: Text(spec),
                    backgroundColor: AppColors.therapistPrimary.withOpacity(
                      0.1,
                    ),
                    deleteIconColor: AppColors.therapistPrimary,
                    onDeleted: () {
                      controller.specialtiesList.remove(spec);
                    },
                  ),
                ),
                ActionChip(
                  avatar: const Icon(
                    Icons.add,
                    size: 16,
                    color: AppColors.therapistPrimary,
                  ),
                  label: const Text(
                    'Add Specialty',
                    style: TextStyle(color: AppColors.therapistPrimary),
                  ),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.therapistPrimary),
                  onPressed: () {
                    _showAddSpecialtyDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSpecialtyDialog(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Specialty'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'e.g., Clinical Psychology',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = textController.text.trim();
                if (text.isNotEmpty &&
                    !controller.specialtiesList.contains(text)) {
                  controller.specialtiesList.add(text);
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
