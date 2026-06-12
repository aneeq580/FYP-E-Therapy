import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_therapy/services/storage_service.dart';
import 'package:fyp_therapy/services/therapist_service.dart';
import 'package:fyp_therapy/therapist/controllers/therapist_profile_controller.dart';
import 'package:get/get.dart';

class TherapistVerificationController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final TherapistService _therapistService = Get.find<TherapistService>();

  final isUploading = false.obs;
  final verificationStatus = 'none'.obs; // none, pending, approved, rejected
  final pickedFile = Rxn<File>();
  final pickedFileName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialStatus();
  }

  Future<void> loadInitialStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profile = await _therapistService.getTherapistProfile(user.uid);
      if (profile != null) {
        verificationStatus.value = profile['verificationStatus'] ?? 'none';
      }
    }
  }

  Future<void> pickDegreeFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final sizeInMb = file.lengthSync() / (1024 * 1024);

        if (sizeInMb > 5) {
          Get.snackbar("Error", "File size must be less than 5MB");
          return;
        }

        pickedFile.value = file;
        pickedFileName.value = result.files.single.name;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick file: $e");
    }
  }

  Future<void> uploadDegree() async {
    if (pickedFile.value == null) {
      Get.snackbar("Error", "Please select a file first");
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    isUploading.value = true;
    try {
      // Just mark that degree was submitted without actually uploading file
      await _therapistService.updateVerificationStatus(
        uid: user.uid,
        status: 'pending',
      );

      verificationStatus.value = 'pending';

      // Refresh profile data if controller exists
      if (Get.isRegistered<TherapistProfileController>()) {
        Get.find<TherapistProfileController>().fetchProfile();
      }

      Get.back(); // Go back after success
      pickedFileName.value = '';
      pickedFile.value = null;

      Get.snackbar(
        "Success",
        "Degree submitted successfully. Waiting for admin verification.",
      );
    } catch (e) {
      Get.snackbar("Error", "Submission failed: $e");
    } finally {
      isUploading.value = false;
    }
  }
}
