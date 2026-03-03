import 'package:cloud_firestore/cloud_firestore.dart';

class MoodEntry {
  final String id;
  final String emoji;
  final String label;
  final int score;
  final Timestamp date;

  MoodEntry({
    required this.id,
    required this.emoji,
    required this.label,
    required this.score,
    required this.date,
  });

  factory MoodEntry.fromMap(Map<String, dynamic> data, String id) {
    return MoodEntry(
      id: id,
      emoji: data['emoji'] as String? ?? '',
      label: data['label'] as String? ?? '',
      score: data['score'] as int? ?? 0,
      date: data['date'] as Timestamp? ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'emoji': emoji,
      'label': label,
      'score': score,
      'date': date,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

