import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/appointment_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/therapist_app_bar.dart';
import '../../routes/app_routes.dart';
import '../widgets/patient_card.dart';
import '../widgets/patient_summary.dart';

/// Shows all unique patients the therapist has accepted.
/// Pulls data from [AppointmentController] streams, deduplicates by patientId,
/// and delegates all UI to reusable widgets from `patient_card.dart`.
class TherapistPatientsScreen extends StatefulWidget {
  const TherapistPatientsScreen({super.key});

  @override
  State<TherapistPatientsScreen> createState() =>
      _TherapistPatientsScreenState();
}

class _TherapistPatientsScreenState extends State<TherapistPatientsScreen> {
  late AppointmentController _ctrl;
  final RxString _query = ''.obs;
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<AppointmentController>()) {
      Get.put(AppointmentController());
    }
    _ctrl = Get.find<AppointmentController>();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _openDetail(PatientSummary patient) {
    Get.toNamed(
      AppRoutes.therapistPatientDetail,
      arguments: {
        'patientId': patient.patientId,
        'patientName': patient.patientName,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_searchFocus.hasFocus,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _searchFocus.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.therapistBackground,
        appBar: const TherapistAppBar(title: 'My Patients'),
        body: Column(
          children: [
            // ── Search bar ────────────────────────────────────────────────
            _PatientsSearchBar(
              controller: _searchCtrl,
              focusNode: _searchFocus,
              query: _query,
            ),
            // ── List ──────────────────────────────────────────────────────
            Expanded(
              child: Obx(() {
                final allAppointments = [
                  ..._ctrl.therapistUpcomingAppointments,
                  ..._ctrl.therapistCompletedAppointments,
                ];

                final patients = buildPatientSummaries(allAppointments);

                final q = _query.value.trim().toLowerCase();
                final filtered = q.isEmpty
                    ? patients
                    : patients
                          .where((p) => p.patientName.toLowerCase().contains(q))
                          .toList();

                if (allAppointments.isEmpty) {
                  return _EmptyState(
                    icon: Icons.people_outline_rounded,
                    message:
                        'No patients yet.\nPatients appear here after you\naccept their session request.',
                  );
                }

                if (filtered.isEmpty) {
                  return _EmptyState(
                    icon: Icons.search_off_rounded,
                    message: 'No patients match your search.',
                  );
                }

                return Column(
                  children: [
                    PatientStatsBar(totalPatients: patients.length),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => PatientCard(
                          patient: filtered[i],
                          onTap: () => _openDetail(filtered[i]),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _PatientsSearchBar  –  local to this screen, not needed elsewhere
// ---------------------------------------------------------------------------

class _PatientsSearchBar extends StatelessWidget {
  const _PatientsSearchBar({
    required this.controller,
    required this.focusNode,
    required this.query,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final RxString query;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.therapistSecondary,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: (v) => query.value = v,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'Search patients…',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Colors.white70,
            size: 20,
          ),
          suffixIcon: Obx(
            () => query.value.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      controller.clear();
                      query.value = '';
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white70,
                      size: 18,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.15),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _EmptyState  –  local, only used here
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.therapistPrimary,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.therapistSecondary),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyTextSecondary.copyWith(
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
