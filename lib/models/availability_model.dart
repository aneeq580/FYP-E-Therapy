import 'package:cloud_firestore/cloud_firestore.dart';

class TimeSlot {
  final String start; // e.g., "09:00"
  final String end;   // e.g., "17:00"

  TimeSlot({required this.start, required this.end});

  Map<String, dynamic> toMap() {
    return {
      'start': start,
      'end': end,
    };
  }

  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      start: map['start'] ?? '09:00',
      end: map['end'] ?? '17:00',
    );
  }
}

class AvailabilityModel {
  final Map<String, List<TimeSlot>> weeklyAvailability;
  final String timezone;
  final List<DateTime> specificDates; // Optional: unique dates with different availability

  AvailabilityModel({
    required this.weeklyAvailability,
    this.timezone = 'Europe/Lisbon',
    this.specificDates = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'weeklyAvailability': weeklyAvailability.map((key, value) => MapEntry(key, value.map((slot) => slot.toMap()).toList())),
      'timezone': timezone,
      'specificDates': specificDates.map((date) => Timestamp.fromDate(date)).toList(),
    };
  }

  factory AvailabilityModel.fromMap(Map<String, dynamic> map) {
    final weeklyMap = map['weeklyAvailability'] as Map<String, dynamic>? ?? {};
    final convertedWeekly = weeklyMap.map((key, value) {
      final list = value as List<dynamic>? ?? [];
      return MapEntry(key, list.map((item) => TimeSlot.fromMap(item as Map<String, dynamic>)).toList());
    });

    return AvailabilityModel(
      weeklyAvailability: convertedWeekly,
      timezone: map['timezone'] ?? 'UTC',
      specificDates: (map['specificDates'] as List<dynamic>? ?? [])
          .map((item) => (item as Timestamp).toDate())
          .toList(),
    );
  }

  // Default availability: Mon-Fri 09:00-17:00
  factory AvailabilityModel.defaultAvailability() {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final defaultSlot = TimeSlot(start: '09:00', end: '17:00');
    return AvailabilityModel(
      weeklyAvailability: {
        for (var day in days) day: [defaultSlot]
      },
    );
  }
}
