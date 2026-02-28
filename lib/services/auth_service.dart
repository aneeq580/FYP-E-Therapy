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
  Future<void> createUserRecord({
    required String uid,
    required String email,
    required String role,
    String? fullName,
  }) async {
    final doc = _firestore.collection('users').doc(uid);
    await doc.set({
      'email': email,
      'role': role,
      'fullName': fullName ?? '',
      'createdAt': FieldValue.serverTimestamp(),
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

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
