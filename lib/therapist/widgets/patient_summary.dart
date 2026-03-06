import '../../models/appointment_model.dart';

// ---------------------------------------------------------------------------
// PatientSummary  –  pure data, no Flutter dependency
// ---------------------------------------------------------------------------

/// One summary record per unique patient, derived from a flat list of
/// [AppointmentModel]s. Used by the patients screen and any future widget
/// that needs a consolidated patient view.
class PatientSummary {
  final String patientId;
  final String patientName;
  final int totalSessions;
  final DateTime? lastSessionDate;

  /// Status of the most recent session (e.g. 'approved', 'completed').
  final String lastStatus;

  const PatientSummary({
    required this.patientId,
    required this.patientName,
    required this.totalSessions,
    this.lastSessionDate,
    required this.lastStatus,
  });
}

/// Converts a flat list of appointments into a deduplicated [PatientSummary]
/// list sorted by most recent session first.
///
/// Pass in whatever appointment lists you want to include (e.g. upcoming +
/// completed). The function groups by [AppointmentModel.patientId].
List<PatientSummary> buildPatientSummaries(
  List<AppointmentModel> appointments,
) {
  // Group by patientId
  final Map<String, List<AppointmentModel>> grouped = {};
  for (final appt in appointments) {
    grouped.putIfAbsent(appt.patientId, () => []).add(appt);
  }

  final summaries = grouped.entries.map((entry) {
    final list = List<AppointmentModel>.from(entry.value)
      ..sort((a, b) => b.date.compareTo(a.date)); // newest first
    final latest = list.first;
    return PatientSummary(
      patientId: entry.key,
      patientName: latest.patientName.isNotEmpty
          ? latest.patientName
          : 'Unknown',
      totalSessions: list.length,
      lastSessionDate: latest.date.toDate(),
      lastStatus: latest.status,
    );
  }).toList();

  // Sort by most recent session first
  summaries.sort(
    (a, b) => (b.lastSessionDate ?? DateTime(0)).compareTo(
      a.lastSessionDate ?? DateTime(0),
    ),
  );

  return summaries;
}
