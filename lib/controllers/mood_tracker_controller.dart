import 'package:get/get.dart';
import '../models/mood_entry.dart';
import '../services/mood_service.dart';

/// Controller for Mood Tracker screen.
class MoodTrackerController extends GetxController {
  final selectedMood = RxnString();

  final RxList<MoodEntry> moodHistory = <MoodEntry>[].obs;
  final RxString progressSummary = ''.obs;
  final RxString suggestion = ''.obs;

  late final MoodService _moodService;

  @override
  void onInit() {
    super.onInit();
    _moodService = Get.find<MoodService>();

    _moodService.recentMoods(days: 14).listen((entries) {
      moodHistory.assignAll(entries);
      _updateInsights();
    });
  }

  void setMood(String emoji) {
    selectedMood.value = emoji;
    _saveTodayMood(emoji);
  }

  int _scoreForEmoji(String emoji) {
    switch (emoji) {
      case '😢':
        return 1;
      case '😐':
        return 2;
      case '🙂':
        return 3;
      case '😊':
        return 4;
      case '😄':
        return 5;
      default:
        return 0;
    }
  }

  String _labelForEmoji(String emoji) {
    switch (emoji) {
      case '😢':
        return 'Sad';
      case '😐':
        return 'Neutral';
      case '🙂':
        return 'Good';
      case '😊':
        return 'Happy';
      case '😄':
        return 'Great';
      default:
        return 'Unknown';
    }
  }

  Future<void> _saveTodayMood(String emoji) async {
    final label = _labelForEmoji(emoji);
    final score = _scoreForEmoji(emoji);
    await _moodService.saveTodayMood(
      emoji: emoji,
      label: label,
      score: score,
    );
  }

  void _updateInsights() {
    if (moodHistory.isEmpty) {
      progressSummary.value = 'No mood data yet.';
      suggestion.value =
          'Start tracking your mood daily to see your progress over time.';
      return;
    }

    final scores = moodHistory.map((e) => e.score).where((s) => s > 0).toList();
    if (scores.isEmpty) {
      progressSummary.value = 'No mood scores available.';
      suggestion.value =
          'Try selecting a mood each day to unlock personalized suggestions.';
      return;
    }

    final total = scores.fold<int>(0, (sum, s) => sum + s);
    final avg = total / scores.length;

    String moodLevel;
    if (avg <= 2) {
      moodLevel = 'low';
    } else if (avg < 4) {
      moodLevel = 'moderate';
    } else {
      moodLevel = 'positive';
    }

    progressSummary.value =
        'Your average mood over the last ${scores.length} days is $moodLevel.';

    switch (moodLevel) {
      case 'low':
        suggestion.value =
            'Your moods have been on the lower side. Consider reaching out to your therapist, using relaxation exercises, or journaling how you feel.';
        break;
      case 'moderate':
        suggestion.value =
            'Your mood is balancing between ups and downs. Try noting what helps on better days and repeat those habits.';
        break;
      case 'positive':
        suggestion.value =
            'You\'ve been feeling mostly positive. Keep practicing the routines that support your wellbeing and share what works with your therapist.';
        break;
      default:
        suggestion.value =
            'Keep tracking your mood daily to receive more tailored suggestions.';
    }
  }
}

