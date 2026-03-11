import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/services/auth_service.dart';

class TherapistProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> profileData = <String, dynamic>{}.obs;

  // Observable fields for editing
  final RxString fullName = ''.obs;
  final RxString specialty = ''.obs;
  final RxString bio = ''.obs;
  final RxString phone = ''.obs;
  final RxDouble rating = 0.0.obs;
  final RxInt experience = 0.obs;
  final RxString education = ''.obs;
  final RxDouble hourlyRate = 0.0.obs;
  final RxString profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
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
  }

  Future<void> updateProfile() async {
    final user = _authService.currentUser.value;
    if (user == null) return;

    isLoading.value = true;
    try {
      final updatedData = {
        'fullName': fullName.value,
        'specialty': specialty.value,
        'bio': bio.value,
        'phone': phone.value,
        'experience': experience.value,
        'education': education.value,
        'hourlyRate': hourlyRate.value,
        'profileImageUrl': profileImageUrl.value,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _authService.updateUserProfile(user.uid, updatedData);
      profileData.addAll(updatedData);
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
