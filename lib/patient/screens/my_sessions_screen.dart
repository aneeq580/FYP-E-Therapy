import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/session_card.dart';

/// My Sessions Screen - Track therapy progress and sessions
class MySessionsScreen extends StatelessWidget {
  const MySessionsScreen({super.key});

  // Static session data (UI only)
  static const List<Map<String, dynamic>> upcomingSessions = [
    {
      'date': 'Mon 15',
      'time': '10:00 AM',
      'therapist': 'Dr. Sarah Johnson',
      'status': 'Upcoming',
    },
    {
      'date': 'Wed 17',
      'time': '2:30 PM',
      'therapist': 'Dr. Michael Chen',
      'status': 'Upcoming',
    },
    {
      'date': 'Fri 19',
      'time': '11:00 AM',
      'therapist': 'Dr. Emily Rodriguez',
      'status': 'Upcoming',
    },
  ];

  static const List<Map<String, dynamic>> pastSessions = [
    {
      'date': 'Mon 8',
      'time': '10:00 AM',
      'therapist': 'Dr. Sarah Johnson',
      'status': 'Completed',
    },
    {
      'date': 'Wed 3',
      'time': '2:30 PM',
      'therapist': 'Dr. Michael Chen',
      'status': 'Completed',
    },
    {
      'date': 'Mon 1',
      'time': '11:00 AM',
      'therapist': 'Dr. Emily Rodriguez',
      'status': 'Completed',
    },
    {
      'date': 'Fri 25',
      'time': '3:00 PM',
      'therapist': 'Dr. James Wilson',
      'status': 'Cancelled',
    },
  ];

  void _handleSessionTap(String sessionId) {
    // TODO: Navigate to session details screen
    // Navigator.push(context, ...);
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spacingMedium,
        AppSizes.spacingLarge,
        AppSizes.spacingMedium,
        AppSizes.spacingMedium,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Sessions'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Sessions Section
            _buildSectionTitle('Upcoming Sessions'),

            // Upcoming Sessions List
            ...upcomingSessions.map((session) {
              return SessionCard(
                date: session['date'] as String,
                time: session['time'] as String,
                therapistName: session['therapist'] as String,
                status: session['status'] as String,
                onTap: () => _handleSessionTap(session['date'] as String),
              );
            }).toList(),

            // Past Sessions Section
            _buildSectionTitle('Past Sessions'),

            // Past Sessions List
            ...pastSessions.map((session) {
              return SessionCard(
                date: session['date'] as String,
                time: session['time'] as String,
                therapistName: session['therapist'] as String,
                status: session['status'] as String,
                onTap: () => _handleSessionTap(session['date'] as String),
              );
            }).toList(),

            const SizedBox(height: AppSizes.spacingLarge),
          ],
        ),
      ),
    );
  }
}
