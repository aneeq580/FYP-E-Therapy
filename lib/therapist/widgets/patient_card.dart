import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import 'patient_summary.dart';

// ---------------------------------------------------------------------------
// PatientCard  –  reusable card, importable from any screen
// ---------------------------------------------------------------------------

/// A card that displays a [PatientSummary]. Provide [onTap] to handle
/// navigation. This widget has no routing or controller dependency.
///
/// Example usage:
/// ```dart
/// PatientCard(
///   patient: summary,
///   onTap: () => Get.toNamed(AppRoutes.therapistPatientDetail, arguments: {...}),
/// )
/// ```
class PatientCard extends StatelessWidget {
  const PatientCard({super.key, required this.patient, required this.onTap});

  final PatientSummary patient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final lastDate = patient.lastSessionDate != null
        ? DateFormat('MMM d, yyyy').format(patient.lastSessionDate!)
        : '—';

    return Material(
      color: const Color(0xFFE8D5F8), // Distinct lavender tint — same purple hue, noticeably different shade
      borderRadius: BorderRadius.circular(18),
      elevation: 2,
      shadowColor: Colors.black12,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // ── Gradient Avatar ─────────────────────────────────────────
              PatientAvatar(name: patient.patientName),
              const SizedBox(width: 14),
              // ── Info ────────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.patientName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Last: $lastDate',
                          style: AppTextStyles.bodyTextSecondary.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        SessionCountChip(count: patient.totalSessions),
                        const SizedBox(width: 8),
                        PatientStatusChip(status: patient.lastStatus),
                      ],
                    ),
                  ],
                ),
              ),
              // ── Arrow ───────────────────────────────────────────────────
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PatientAvatar  –  gradient circle avatar with initials
// ---------------------------------------------------------------------------

/// Standalone gradient avatar. Reusable wherever you need a patient avatar.
class PatientAvatar extends StatelessWidget {
  const PatientAvatar({
    super.key,
    required this.name,
    this.size = 54,
    this.fontSize = 18,
  });

  final String name;

  /// Diameter of the circle.
  final double size;

  /// Font size of the initials text.
  final double fontSize;

  static const List<List<Color>> _palettes = [
    [AppColors.therapistPrimary, AppColors.therapistSecondary], // Maroon
    [AppColors.primary, AppColors.primaryLight], // Red
    [AppColors.secondary, Color(0xFF607D8B)], // Blue Grey
    [Color(0xFF8D6E63), Color(0xFF5D4037)], // Brown (Warm contrast)
    [Color(0xFF78909C), Color(0xFF455A64)], // Slate
    [Color(0xFFB71C1C), Color(0xFF880E4F)], // Deep Red/Wine
    [Color(0xFF546E7A), Color(0xFF263238)], // Dark Grey
  ];

  List<Color> get _colors {
    if (name.isEmpty) return _palettes[0];
    return _palettes[name.codeUnitAt(0) % _palettes.length];
  }

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SessionCountChip  –  e.g. "3 sessions"
// ---------------------------------------------------------------------------

/// Reusable chip showing number of sessions.
class SessionCountChip extends StatelessWidget {
  const SessionCountChip({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF0E3FB), // Soft purple background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_note_rounded,
            size: 12,
            color: AppColors.primaryDark,
          ),
          const SizedBox(width: 4),
          Text(
            '$count ${count == 1 ? 'session' : 'sessions'}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PatientStatusChip  –  color-coded status badge
// ---------------------------------------------------------------------------

/// Reusable status badge for a patient's session state.
/// Supports: `completed`, `approved`, `upcoming`, `started`, fallback.
class PatientStatusChip extends StatelessWidget {
  const PatientStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      'completed' => (
        'Session Ended',
        const Color(0xFFF0E3FB), // Soft purple background
        AppColors.primaryDark,
      ),
      'approved' || 'upcoming' => (
        'Active',
        const Color(0xFFF5E8FD), // Light lavender background
        AppColors.secondaryDark,
      ),
      'started' => (
        'In Session',
        const Color(0xFFF0E3FB), // Soft purple background
        AppColors.secondaryDark,
      ),
      _ => ('Pending', AppColors.backgroundLight, AppColors.textSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PatientStatsBar  –  banner at the top of the patients list
// ---------------------------------------------------------------------------

/// A full-width gradient banner showing total patient count.
/// Reusable in any screen needing a summary header.
class PatientStatsBar extends StatelessWidget {
  const PatientStatsBar({super.key, required this.totalPatients});

  final int totalPatients;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD0A1E8), Color(0xFFE8C8F5)], // Light lavender gradient
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.people_alt_rounded,
            color: AppColors.primaryDark,
            size: 28,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$totalPatients '
                '${totalPatients == 1 ? 'Patient' : 'Patients'}',
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Under your care',
                style: TextStyle(
                  color: AppColors.primaryDark.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
