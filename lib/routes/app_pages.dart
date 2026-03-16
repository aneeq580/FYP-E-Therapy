import 'package:get/get.dart';
import 'package:fyp_therapy/views/auth/role_selection/role_selection_screen.dart';
import 'package:fyp_therapy/views/auth/login/login_screen.dart';
import 'package:fyp_therapy/views/auth/signup/signup_screen.dart';
import 'package:fyp_therapy/views/auth/forgot_password/forgot_password_screen.dart';
import 'package:fyp_therapy/patient/screens/patient_home_screen.dart';
import 'package:fyp_therapy/patient/screens/therapist_list_screen.dart';
import 'package:fyp_therapy/patient/screens/book_session_screen.dart';
import 'package:fyp_therapy/patient/screens/my_sessions_screen.dart';
import 'package:fyp_therapy/patient/screens/mood_tracker_screen.dart';
import 'package:fyp_therapy/patient/screens/resources_screen.dart';
import 'package:fyp_therapy/patient/screens/emergency_screen.dart';
import 'package:fyp_therapy/patient/settings/screens/settings_main_screen.dart';
import 'package:fyp_therapy/patient/settings/screens/notifications_screen.dart';
import 'package:fyp_therapy/patient/settings/screens/privacy_security_screen.dart';
import 'package:fyp_therapy/patient/settings/screens/dark_mode_screen.dart';
import 'package:fyp_therapy/patient/settings/screens/language_screen.dart';
import 'package:fyp_therapy/patient/settings/screens/help_support_screen.dart';
import 'package:fyp_therapy/chat/screens/chat_list_screen.dart';
import 'package:fyp_therapy/chat/screens/sessions_list_screen.dart';
import 'package:fyp_therapy/chat/screens/chat_screen.dart';
import 'package:fyp_therapy/patient/profile/patient_profile_screen.dart';
import 'package:fyp_therapy/patient/screens/patient_reports_screen.dart';

import 'package:fyp_therapy/therapist/screens/therapist_home_screen.dart';
import 'package:fyp_therapy/therapist/screens/therapist_appointments_screen.dart';
import 'package:fyp_therapy/therapist/screens/pending_sessions_screen.dart';
import 'package:fyp_therapy/therapist/screens/therapist_profile_screen.dart';
import 'package:fyp_therapy/therapist/screens/therapist_patients_screen.dart';
import 'package:fyp_therapy/therapist/screens/therapist_patient_detail_screen.dart';
import 'package:fyp_therapy/therapist/bindings/therapist_profile_binding.dart';
import 'package:fyp_therapy/therapist/screens/therapist_reports_screen.dart';
import 'package:fyp_therapy/therapist/screens/create_report_screen.dart';

import 'package:fyp_therapy/therapist/screens/edit_therapist_profile_screen.dart';
import 'app_routes.dart';
import 'package:fyp_therapy/bindings/auth_binding.dart';
import 'package:fyp_therapy/bindings/book_session_binding.dart';
import 'package:fyp_therapy/bindings/mood_tracker_binding.dart';

/// Central GetX page configuration.
class AppPages {
  static final routes = <GetPage>[
    // Auth
    GetPage(
      name: AppRoutes.roleSelection,
      page: () => const RoleSelectionScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(role: Get.arguments as String? ?? ''),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignupScreen(role: Get.arguments as String? ?? ''),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),

    // Patient
    GetPage(name: AppRoutes.patientHome, page: () => const PatientHomeScreen()),
    GetPage(
      name: AppRoutes.therapistList,
      page: () => const TherapistListScreen(),
    ),
    GetPage(
      name: AppRoutes.bookSession,
      page: () => const BookSessionScreen(),
      binding: BookSessionBinding(),
    ),
    GetPage(
      name: AppRoutes.mySessions,
      page: () => const MySessionsScreen(),
      // binding: SessionBinding(),
    ),
    // patient chat (arguments: sessionId)
    GetPage(
      name: AppRoutes.patientChat,
      page: () =>
          ChatScreen(sessionId: Get.arguments as String, isTherapist: false),
    ),
    // therapist chat (arguments: sessionId)
    GetPage(
      name: AppRoutes.therapistChat,
      page: () =>
          ChatScreen(sessionId: Get.arguments as String, isTherapist: true),
    ),
    // active sessions (argument: bool isTherapist)
    GetPage(
      name: AppRoutes.activeSessions,
      page: () {
        final bool isTherapistArg = (Get.arguments is bool)
            ? (Get.arguments as bool)
            : false;
        return SessionsListScreen(isTherapist: isTherapistArg);
      },
    ),
    // chat conversation list (argument: bool isTherapist)
    GetPage(
      name: AppRoutes.chatList,
      page: () {
        final bool isTherapistArg = (Get.arguments is bool)
            ? (Get.arguments as bool)
            : false;
        return ChatListScreen(isTherapist: isTherapistArg);
      },
    ),
    GetPage(
      name: AppRoutes.moodTracker,
      page: () => const MoodTrackerScreen(),
      binding: MoodTrackerBinding(),
    ),
    GetPage(name: AppRoutes.resources, page: () => const ResourcesScreen()),
    GetPage(name: AppRoutes.emergency, page: () => const EmergencyScreen()),
    GetPage(
      name: AppRoutes.patientSettings,
      page: () => const SettingsMainScreen(),
    ),
    GetPage(
      name: AppRoutes.patientSettingsNotifications,
      page: () => const NotificationsScreen(),
    ),
    GetPage(
      name: AppRoutes.patientSettingsPrivacy,
      page: () => const PrivacySecurityScreen(),
    ),
    GetPage(
      name: AppRoutes.patientSettingsDarkMode,
      page: () => const DarkModeScreen(),
    ),
    GetPage(
      name: AppRoutes.patientSettingsLanguage,
      page: () => const LanguageScreen(),
    ),
    GetPage(
      name: AppRoutes.patientSettingsHelp,
      page: () => const HelpSupportScreen(),
    ),
    GetPage(
      name: AppRoutes.patientProfile,
      page: () => const PatientProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.patientReports,
      page: () => const PatientReportsScreen(),
    ),

    // Therapist
    GetPage(
      name: AppRoutes.therapistHome,
      page: () => const TherapistHomeScreen(),
      binding: TherapistProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.appointmentRequests,
      page: () => const TherapistAppointmentsScreen(),
    ),
    GetPage(
      name: AppRoutes.pendingSessions,
      page: () => const PendingSessionsScreen(),
    ),
    GetPage(
      name: AppRoutes.therapistProfile,
      page: () => const TherapistProfileScreen(),
      binding: TherapistProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editTherapistProfile,
      page: () => const EditTherapistProfileScreen(),
      binding: TherapistProfileBinding(),
    ),
    // therapist patient routes
    GetPage(
      name: AppRoutes.therapistPatients,
      page: () => const TherapistPatientsScreen(),
    ),
    GetPage(
      name: AppRoutes.therapistPatientDetail,
      page: () => const TherapistPatientDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.therapistReports,
      page: () => const TherapistReportsScreen(),
    ),
    GetPage(
      name: AppRoutes.createReport,
      page: () => const CreateReportScreen(),
    ),
  ];
}
