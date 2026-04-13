import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static const String _onboardingSeenKey = 'onboarding_seen';

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingSeenKey) ?? false;
  }

  Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingSeenKey, true);
  }

  /// Uploads a degree certificate to Firebase Storage.
  /// Path: therapist_degrees/{therapistId}/{filename}
  Future<String> uploadDegree({
    required String therapistId,
    required File file,
    required String filename,
  }) async {
    try {
      final ref = _storage
          .ref()
          .child('therapist_degrees')
          .child(therapistId)
          .child(filename);

      // Upload the file
      final uploadTask = ref.putFile(file);

      // Wait for completion and get the URL
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw 'Failed to upload degree: $e';
    }
  }
}
