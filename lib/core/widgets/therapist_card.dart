import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// Reusable widget for therapist profile card
class TherapistCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final String? photoUrl;
  final int experience;
  final double hourlyRate;
  final List<String> tags;
  final VoidCallback? onViewProfile;

  const TherapistCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.experience,
    required this.hourlyRate,
    this.tags = const [],
    this.photoUrl,
    this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Therapist Photo with Status Dot
              Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.iconBgTherapists,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: photoUrl != null && photoUrl!.isNotEmpty
                          ? (photoUrl!.startsWith('assets/')
                              ? Image.asset(
                                  photoUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.person, size: 40, color: AppColors.iconTherapists),
                                )
                              : Image.network(
                                  photoUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.person, size: 40, color: AppColors.iconTherapists),
                                ))
                          : const Icon(Icons.person, size: 40, color: AppColors.iconTherapists),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50), // Green status dot
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Info Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A), // Dark Navy
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialty,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B), // Muted Blue/Grey
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Text(
                          "$experience+ yrs",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.star, size: 16, color: Color(0xFFFBBF24)),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tags Wrap
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...tags.take(3).map((tag) => _buildTag(tag)),
              if (tags.length > 3) _buildTag("+${tags.length - 3}"),
            ],
          ),
          const SizedBox(height: 20),

          // Bottom Row: Price & View Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\$${hourlyRate.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const TextSpan(
                      text: " /session",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onViewProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488), // Teal color from screenshot
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "View",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFA), // Light Teal BG
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF0D9488), // Teal Text
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
