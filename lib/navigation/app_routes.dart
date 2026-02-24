import 'package:flutter/material.dart';
import 'package:fyp_therapy/auth/RoleSelection/role_selection_screen.dart';
import 'package:fyp_therapy/auth/LoginScreen/login_screen.dart';
import 'package:fyp_therapy/auth/SignupScreen/signup_screen.dart';
import 'package:fyp_therapy/patient/screens/patient_home_screen.dart';
import 'package:fyp_therapy/patient/screens/therapist_list_screen.dart';
import 'package:fyp_therapy/patient/screens/book_session_screen.dart';
import 'package:fyp_therapy/patient/screens/my_sessions_screen.dart';
import 'package:fyp_therapy/patient/screens/chat_screen.dart';
import 'package:fyp_therapy/patient/screens/mood_tracker_screen.dart';
import 'package:fyp_therapy/patient/screens/resources_screen.dart';
import 'package:fyp_therapy/patient/screens/emergency_screen.dart';
import 'package:fyp_therapy/patient/screens/settings_screen.dart';
import 'package:fyp_therapy/patient/screens/chat_detail_screen.dart';
import 'package:fyp_therapy/patient/profile/patient_profile_screen.dart';
import 'package:fyp_therapy/therapist/screens/therapist_home_screen.dart';
import 'package:fyp_therapy/therapist/screens/appointment_requests_screen.dart';
import 'package:fyp_therapy/therapist/screens/pending_sessions_screen.dart';
import 'package:fyp_therapy/therapist/screens/therapist_chat_screen.dart';
import 'package:fyp_therapy/therapist/screens/therapist_profile_screen.dart';

class AppRoutes {
  // Route names
  static const String roleSelection = '/roleSelection';
  static const String login = '/login';
  static const String signup = '/signup';

  // Patient routes
  static const String patientHome = '/patientHome';
  static const String therapistList = '/therapistList';
  static const String bookSession = '/bookSession';
  static const String mySessions = '/mySessions';
  static const String patientChat = '/patientChat';
  static const String chatDetail = '/chatDetail';
  static const String moodTracker = '/moodTracker';
  static const String resources = '/resources';
  static const String emergency = '/emergency';
  static const String patientSettings = '/patientSettings';
  static const String patientProfile = '/patientProfile';

  // Therapist routes
  static const String therapistHome = '/therapistHome';
  static const String appointmentRequests = '/appointmentRequests';
  static const String pendingSessions = '/pendingSessions';
  static const String therapistChat = '/therapistChat';
  static const String therapistProfile = '/therapistProfile';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // Auth routes
      roleSelection: (context) => const RoleSelectionScreen(),
      login: (context) => LoginScreen(
        role: ModalRoute.of(context)?.settings.arguments as String? ?? '',
      ),
      signup: (context) => SignupScreen(
        role: ModalRoute.of(context)?.settings.arguments as String? ?? '',
      ),

      // Patient routes
      patientHome: (context) => const PatientHomeScreen(),
      therapistList: (context) => const TherapistListScreen(),
      bookSession: (context) => const BookSessionScreen(),
      mySessions: (context) => const MySessionsScreen(),
      patientChat: (context) => const ChatScreen(),
      chatDetail: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments
                as Map<String, dynamic>? ??
            {};
        return ChatDetailScreen(
          chatId: args['chatId'] as String? ?? '',
          name: args['name'] as String? ?? '',
        );
      },
      moodTracker: (context) => const MoodTrackerScreen(),
      resources: (context) => const ResourcesScreen(),
      emergency: (context) => const EmergencyScreen(),
      patientSettings: (context) => const SettingsScreen(),
      patientProfile: (context) => const PatientProfileScreen(),

      // Therapist routes
      therapistHome: (context) => const TherapistHomeScreen(),
      appointmentRequests: (context) => const AppointmentRequestsScreen(),
      pendingSessions: (context) => const PendingSessionsScreen(),
      therapistChat: (context) => const TherapistChatScreen(),
      therapistProfile: (context) => const TherapistProfileScreen(),
    };
  }

  // Named route navigation helper
  static void navigateTo(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  // Named route replacement navigation helper
  static void navigateReplacementTo(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }

  // Navigate and clear stack
  static void navigateClearStackTo(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
}
