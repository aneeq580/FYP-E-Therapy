import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/services/auth_service.dart';

class PatientProfileController extends GetxController {
  PatientProfileController() : _authService = Get.find<AuthService>();

  final AuthService _authService;
  final isLoading = false.obs;
  final hasShownCompletionPrompt = false.obs;
  final hasLoadedInitialProfile = false.obs;

  final fullName = ''.obs;
  final email = ''.obs;
  final age = RxnInt();
  final gender = ''.obs;
  final joinedAt = Rxn<DateTime>();
  final profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Load immediately if a user is already available.
    final user = _authService.currentUser.value;
    if (user != null) {
      _loadProfileForUid(user.uid, fallbackEmail: user.email);
    }

    // React to future auth state changes.
    ever<User?>(_authService.currentUser, (user) {
      if (user != null) {
        _loadProfileForUid(user.uid, fallbackEmail: user.email);
      } else {
        _clearProfile();
      }
    });
  }

  void _clearProfile() {
    fullName.value = '';
    email.value = '';
    age.value = null;
    gender.value = '';
    joinedAt.value = null;
    profileImageUrl.value = '';
  }

  bool get isProfileIncomplete {
    // Require at least full name, age, and gender.
    final hasName = fullName.value.trim().isNotEmpty;
    final hasAge = age.value != null && age.value! > 0;
    final hasGender = gender.value.trim().isNotEmpty;
    return !(hasName && hasAge && hasGender);
  }

  Future<void> _loadProfileForUid(String uid, {String? fallbackEmail}) async {
    isLoading.value = true;
    try {
      final data = await _authService.fetchUserProfile(uid);
      if (data == null) {
        // Fallback values from FirebaseAuth if Firestore doc is missing.
        email.value = fallbackEmail ?? '';
        hasLoadedInitialProfile.value = true;
        return;
      }

      fullName.value = (data['fullName'] as String?)?.trim() ?? '';
      email.value = (data['email'] as String?)?.trim() ?? (fallbackEmail ?? '');
      age.value = data['age'] is int ? data['age'] as int : null;
      gender.value = (data['gender'] as String?)?.trim() ?? '';

      final joinedField = data['joinedAt'] ?? data['createdAt'];
      if (joinedField is Timestamp) {
        joinedAt.value = joinedField.toDate();
      } else {
        joinedAt.value = null;
      }

      profileImageUrl.value =
          (data['profileImageUrl'] as String?)?.trim() ?? '';
      hasLoadedInitialProfile.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  String get displayName {
    if (fullName.value.trim().isNotEmpty) {
      return fullName.value.trim();
    }
    if (email.value.contains('@')) {
      return email.value.split('@').first;
    }
    return 'Patient';
  }

  String get displayEmail => email.value;

  String get formattedJoinedDate {
    final date = joinedAt.value;
    if (date == null) return 'Not set';

    const monthNames = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final monthName = monthNames[date.month - 1];
    return '$monthName ${date.day}, ${date.year}';
  }

  Future<void> saveProfileEdits({
    required String newFullName,
    required String newEmail,
    required int? newAge,
    required String newGender,
    required String newProfileImageUrl,
  }) async {
    final user = _authService.currentUser.value;
    if (user == null) return;

    isLoading.value = true;
    try {
      final payload = <String, dynamic>{
        'fullName': newFullName.trim().isEmpty
            ? FieldValue.delete()
            : newFullName.trim(),
        'email': newEmail.trim().isEmpty
            ? FieldValue.delete()
            : newEmail.trim(),
        'age': newAge ?? FieldValue.delete(),
        'gender': newGender.trim().isEmpty
            ? FieldValue.delete()
            : newGender.trim(),
        'profileImageUrl': newProfileImageUrl.trim().isEmpty
            ? FieldValue.delete()
            : newProfileImageUrl.trim(),
      };

      await _authService.updateUserProfile(user.uid, payload);

      // Update local state so UI reflects immediately.
      fullName.value = newFullName.trim();
      email.value = newEmail.trim();
      age.value = newAge;
      gender.value = newGender.trim();
      profileImageUrl.value = newProfileImageUrl.trim();
    } finally {
      isLoading.value = false;
    }
  }
}
