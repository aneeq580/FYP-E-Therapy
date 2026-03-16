import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/services/auth_service.dart';

class TherapistProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> profileData = <String, dynamic>{}.obs;

  // Observable fields for UI display
  final RxString fullName = ''.obs;
  final RxString specialty = ''.obs;
  final RxString bio = ''.obs;
  final RxString phone = ''.obs;
  final RxDouble rating = 0.0.obs;
  final RxInt experience = 0.obs;
  final RxString education = ''.obs;
  final RxDouble hourlyRate = 0.0.obs;
  final RxString profileImageUrl = ''.obs;

  // Controllers for editing
  late TextEditingController nameController;
  late TextEditingController specialtyController;
  late TextEditingController bioController;
  late TextEditingController phoneController;
  late TextEditingController experienceController;
  late TextEditingController educationController;
  late TextEditingController hourlyRateController;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    specialtyController = TextEditingController();
    bioController = TextEditingController();
    phoneController = TextEditingController();
    experienceController = TextEditingController();
    educationController = TextEditingController();
    hourlyRateController = TextEditingController();
    fetchProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    specialtyController.dispose();
    bioController.dispose();
    phoneController.dispose();
    experienceController.dispose();
    educationController.dispose();
    hourlyRateController.dispose();
    super.onClose();
  }

  Future<void> fetchProfile() async {
    final user = _authService.currentUser.value;
    if (user == null) return;

    isLoading.value = true;
    try {
      final data = await _authService.fetchUserProfile(user.uid);
      if (data != null) {
        profileData.value = data;
        _populateFields(data);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _populateFields(Map<String, dynamic> data) {
    fullName.value = data['fullName'] ?? '';
    specialty.value = data['specialty'] ?? 'General Therapist';
    bio.value = data['bio'] ?? '';
    phone.value = data['phone'] ?? '';
    rating.value = (data['rating'] as num?)?.toDouble() ?? 5.0;
    experience.value = data['experience'] as int? ?? 0;
    education.value = data['education'] ?? '';
    hourlyRate.value = (data['hourlyRate'] as num?)?.toDouble() ?? 0.0;
    profileImageUrl.value = data['profileImageUrl'] ?? '';

    // Update controllers
    nameController.text = fullName.value;
    specialtyController.text = specialty.value;
    bioController.text = bio.value;
    phoneController.text = phone.value;
    experienceController.text = experience.value.toString();
    educationController.text = education.value;
    hourlyRateController.text = hourlyRate.value.toStringAsFixed(0);
  }

  Future<void> updateProfile() async {
    final user = _authService.currentUser.value;
    if (user == null) return;

    isLoading.value = true;
    try {
      final updatedData = {
        'fullName': nameController.text.trim(),
        'specialty': specialtyController.text.trim(),
        'bio': bioController.text.trim(),
        'phone': phoneController.text.trim(),
        'experience': int.tryParse(experienceController.text) ?? 0,
        'education': educationController.text.trim(),
        'hourlyRate': double.tryParse(hourlyRateController.text) ?? 0.0,
        'profileImageUrl': profileImageUrl.value,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _authService.updateUserProfile(user.uid, updatedData);
      
      // Update observable fields immediately
      fullName.value = updatedData['fullName'] as String;
      specialty.value = updatedData['specialty'] as String;
      bio.value = updatedData['bio'] as String;
      phone.value = updatedData['phone'] as String;
      experience.value = updatedData['experience'] as int;
      education.value = updatedData['education'] as String;
      hourlyRate.value = updatedData['hourlyRate'] as double;
      
      profileData.addAll(updatedData);
      Get.back(); // Go back to profile screen
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

