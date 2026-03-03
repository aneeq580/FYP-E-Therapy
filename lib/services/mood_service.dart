import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/mood_entry.dart';

class MoodService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? get _uid => _firebaseAuth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _collection {
    return _firestore.collection('users');
  }

  /// Save or update today's mood for the current user.
  Future<void> saveTodayMood({
    required String emoji,
    required String label,
    required int score,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);

    final docRef = _collection
        .doc(uid)
        .collection('moods')
        .doc('${dayStart.year}-${dayStart.month}-${dayStart.day}');

    final entry = MoodEntry(
      id: docRef.id,
      emoji: emoji,
      label: label,
      score: score,
      date: Timestamp.fromDate(dayStart),
    );

    await docRef.set(entry.toMap(), SetOptions(merge: true));
  }

  /// Stream recent mood history for the current user (last [days] days).
  Stream<List<MoodEntry>> recentMoods({int days = 7}) {
    final uid = _uid;
    if (uid == null) {
      return const Stream<List<MoodEntry>>.empty();
    }

    final now = DateTime.now();
    final fromDate = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: days - 1));

    return _collection
        .doc(uid)
        .collection('moods')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate))
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MoodEntry.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
