import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

/// Service responsible for talking to FirebaseAuth only.
///
/// All higher‑level logic (navigation, validation, UI state) should live
/// in controllers or widgets.
class AuthService extends GetxService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Reactive handle to the currently signed‑in user (or null).
  final Rxn<User> currentUser = Rxn<User>();

  /// Expose the auth state changes stream for consumers that prefer streams.
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  void onInit() {
    super.onInit();
    // Keep [currentUser] in sync with FirebaseAuth using authStateChanges().
    currentUser.bindStream(_firebaseAuth.authStateChanges());
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Create a user document in Firestore to persist profile data such as role.
  ///
  /// This is called right after signup. Additional profile fields like
  /// age / gender / profileImageUrl can be updated later via
  /// [updateUserProfile].
  Future<void> createUserRecord({
    required String uid,
    required String email,
    required String role,
    String? fullName,
    String? phone,
    bool degreeSubmitted = false,
    int? age,
    String? gender,
    String? profileImageUrl,
    DateTime? joinedAt,
  }) async {
    final doc = _firestore.collection('users').doc(uid);
    await doc.set({
      'email': email,
      'role': role,
      'fullName': fullName ?? '',
      if (phone != null) 'phone': phone,
      if (degreeSubmitted && role == 'therapist') 'degreeSubmitted': true,
      if (degreeSubmitted && role == 'therapist')
        'verificationStatus': 'pending',
      // Optional fields – mostly populated/updated later.
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      // Prefer a custom joinedAt if provided, otherwise rely on server time.
      'createdAt': joinedAt != null
          ? Timestamp.fromDate(joinedAt)
          : FieldValue.serverTimestamp(),
      if (joinedAt != null) 'joinedAt': Timestamp.fromDate(joinedAt),
    });
  }

  /// Fetch stored role for a user from Firestore. Returns null if not found.
  Future<String?> fetchUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    final data = doc.data();
    if (data == null) return null;
    return (data['role'] as String?)?.toLowerCase();
  }

  /// Fetch full user profile document from Firestore.
  ///
  /// Returns the raw `Map<String, dynamic>` for flexibility in UI.
  Future<Map<String, dynamic>?> fetchUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  /// Update profile information for the given user.
  ///
  /// Pass data to merge into the user's document. Allows explicit removal by passing FieldValue.delete().
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    if (data.isEmpty) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
