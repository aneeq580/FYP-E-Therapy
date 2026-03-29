import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'therapist_profile_view.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/patient_app_bar.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/therapist_card.dart';

import '../../services/therapist_service.dart';

/// Therapists Screen - Therapist discovery and listing
class TherapistListScreen extends StatefulWidget {
  const TherapistListScreen({
    super.key,
    this.selectedTherapist,
    this.selectedDate,
    this.selectedTime,
    this.isSelectionMode = false,
  });

  final String? selectedTherapist;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final bool isSelectionMode;

  @override
  State<TherapistListScreen> createState() => _TherapistListScreenState();
}

class _TherapistListScreenState extends State<TherapistListScreen> {
  final RxString _query = ''.obs;
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _dismissKeyboard() => _searchFocus.unfocus();

  void _handleViewProfile(Map<String, dynamic> therapist) {
    Get.to(() => TherapistProfileView(therapist: therapist));
  }

  List<String> _getTags(Map<String, dynamic> therapist) {
    // Check if 'specialties' list exists
    if (therapist['specialties'] is List) {
      return List<String>.from(therapist['specialties']);
    }
    // Otherwise split 'specialty' string
    final spec = therapist['specialty'] as String? ?? '';
    if (spec.isEmpty) return ['Wellness', 'General'];

    // If it contains commas, split into tags
    if (spec.contains(',')) {
      return spec.split(',').map((e) => e.trim()).toList();
    }

    // Return the specialty and a default tag
    return [spec, 'Mental Health'];
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<TherapistService>()) {
      Get.put(TherapistService());
    }
    final therapistService = Get.find<TherapistService>();

    return PopScope(
      canPop: !_searchFocus.hasFocus,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _dismissKeyboard();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const PatientAppBar(title: 'Therapists'),
        body: Column(
          children: [
            _SearchBar(
              controller: _searchCtrl,
              focusNode: _searchFocus,
              query: _query,
            ),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: therapistService.getTherapistsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading therapists: ${snapshot.error}',
                      ),
                    );
                  }

                  final therapists = snapshot.data ?? [];

                  if (therapists.isEmpty && _query.value.isEmpty) {
                    return const Center(
                      child: Text('No therapists available yet.'),
                    );
                  }

                  return Obx(() {
                    final q = _query.value.trim().toLowerCase();
                    final filtered = q.isEmpty
                        ? therapists
                        : therapists.where((t) {
                            final name = (t['fullName'] as String? ?? '')
                                .toLowerCase();
                            final spec = (t['specialty'] as String? ?? '')
                                .toLowerCase();
                            return name.contains(q) || spec.contains(q);
                          }).toList();

                    if (filtered.isEmpty) {
                      return _EmptyState(hasQuery: q.isNotEmpty);
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.spacingMedium,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final therapist = filtered[index];
                        return InkWell(
                          onTap: () {
                            if (widget.isSelectionMode) {
                              Get.back(result: therapist);
                            } else {
                              _handleViewProfile(therapist);
                            }
                          },
                          child: TherapistCard(
                            name: therapist['fullName'] as String? ??
                                therapist['name'] as String? ??
                                'Therapist',
                            specialty: therapist['specialty'] as String? ??
                                'General Therapist',
                            rating: (therapist['rating'] as num?)?.toDouble() ??
                                5.0,
                            photoUrl: therapist['profileImageUrl'] as String? ??
                                therapist['photoUrl'] as String?,
                            experience: (therapist['experience'] as num?)?.toInt() ?? 5,
                            hourlyRate: (therapist['hourlyRate'] as num?)?.toDouble() ?? 100.0,
                            tags: _getTags(therapist),
                            onViewProfile: () => _handleViewProfile(therapist),
                          ),
                        );
                      },
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
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
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: (v) => query.value = v,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'Search by name or specialty…',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontSize: 14,
          ),
          prefixIcon: const Center(
            widthFactor: 1.0,
            child: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: Colors.white70,
              size: 16,
            ),
          ),
          suffixIcon: Obx(
            () => query.value.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      controller.clear();
                      query.value = '';
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.circleXmark,
                      color: Colors.white70,
                      size: 16,
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasQuery});

  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const FaIcon(
                FontAwesomeIcons.userDoctor,
                size: 32,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hasQuery ? 'No therapists found' : 'No therapists available',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasQuery
                  ? 'Try a different name or specialty.'
                  : 'Check back later for available therapists.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyTextSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
