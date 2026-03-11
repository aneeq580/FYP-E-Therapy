import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fyp_therapy/core/constants/colors.dart';
import 'package:fyp_therapy/core/widgets/therapist_app_bar.dart';

class AvailabilityScreen extends StatelessWidget {
  const AvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.therapistBackground,
      appBar: const TherapistAppBar(title: "Manage Availability"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Day Selection
            _AvailabilityCard(
              title: "Monday - Friday",
              subtitle: "9:00 AM - 5:00 PM",
            ),

            const SizedBox(height: 16),

            _AvailabilityCard(
              title: "Saturday",
              subtitle: "10:00 AM - 2:00 PM",
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _AvailabilityCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const FaIcon(FontAwesomeIcons.pen),
        ],
      ),
    );
  }
}
