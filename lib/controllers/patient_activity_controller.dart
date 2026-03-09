import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../services/appointment_service.dart';
import '../services/mood_service.dart';

/// Provides real-time activity stats for the currently logged-in patient.
///
/// Exposes three [RxInt] observables that automatically update whenever the
/// underlying Firestore collections change:
///   - [completedSessions]  – sessions with status == 'completed'
///   - [upcomingSessions]   – sessions with status == 'accepted'
///   - [moodCheckIns]       – total mood entries in users/{uid}/moods
class PatientActivityController extends GetxController {
  final AppointmentService _appointmentService = Get.find<AppointmentService>();
  final MoodService _moodService = Get.find<MoodService>();

  final RxInt completedSessions = 0.obs;
  final RxInt upcomingSessions = 0.obs;
  final RxInt moodCheckIns = 0.obs;

  final List<StreamSubscription<int>> _subs = [];

  @override
  void onInit() {
    super.onInit();
    _bindStreams();
  }

  void _bindStreams() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _subs.add(
      _appointmentService
          .getPatientCompletedSessionCount(uid)
          .listen((count) => completedSessions.value = count),
    );

    _subs.add(
      _appointmentService
          .getPatientUpcomingSessionCount(uid)
          .listen((count) => upcomingSessions.value = count),
    );

    _subs.add(
      _moodService
          .getMoodCheckInCount(uid)
          .listen((count) => moodCheckIns.value = count),
    );
  }

  @override
  void onClose() {
    for (final sub in _subs) {
      sub.cancel();
    }
    super.onClose();
  }
}
