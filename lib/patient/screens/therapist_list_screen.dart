import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/therapist_card.dart';

/// Therapists Screen - Therapist discovery and listing
class TherapistListScreen extends StatelessWidget {
  const TherapistListScreen({super.key});

  // Static therapist data (UI only)
  static const List<Map<String, dynamic>> therapists = [
    {
      'name': 'Dr. Sarah Johnson',
      'specialty': 'Anxiety & Depression',
      'rating': 4.8,
      'photoUrl':
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=200&h=200&fit=crop&crop=face',
    },
    {
      'name': 'Dr. Michael Chen',
      'specialty': 'Cognitive Behavioral Therapy',
      'rating': 4.9,
      'photoUrl':
          'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=200&h=200&fit=crop&crop=face',
    },
    {
      'name': 'Dr. Emily Rodriguez',
      'specialty': 'Family & Relationship Therapy',
      'rating': 4.7,
      'photoUrl':
          'https://images.unsplash.com/photo-1594824476966-48c8b964273f?w=200&h=200&fit=crop&crop=face',
    },
    {
      'name': 'Dr. James Wilson',
      'specialty': 'Trauma & PTSD',
      'rating': 4.9,
      'photoUrl':
          'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=200&h=200&fit=crop&crop=face',
    },
    {
      'name': 'Dr. Lisa Anderson',
      'specialty': 'Stress Management',
      'rating': 4.6,
      'photoUrl':
          'https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?w=200&h=200&fit=crop&crop=face',
    },
    {
      'name': 'Dr. David Thompson',
      'specialty': 'Addiction Recovery',
      'rating': 4.8,
      'photoUrl':
          'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=200&h=200&fit=crop&crop=face',
    },
  ];

  void _handleViewProfile(String therapistName) {
    // TODO: Navigate to therapist profile screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => TherapistProfileScreen(name: therapistName),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Therapists'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium),
        itemCount: therapists.length,
        itemBuilder: (context, index) {
          final therapist = therapists[index];
          return TherapistCard(
            name: therapist['name'] as String,
            specialty: therapist['specialty'] as String,
            rating: therapist['rating'] as double,
            photoUrl: therapist['photoUrl'] as String?,
            onViewProfile: () => _handleViewProfile(therapist['name'] as String),
          );
        },
      ),
    );
  }
}
