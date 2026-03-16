/// Central place for all route names used in the app.
class AppRoutes {
  // Auth routes
  static const String roleSelection = '/roleSelection';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';

  // Patient routes
  static const String patientHome = '/patientHome';
  static const String therapistList = '/therapistList';
  static const String bookSession = '/bookSession';
  static const String mySessions = '/mySessions';
  static const String moodTracker = '/moodTracker';
  static const String resources = '/resources';
  static const String emergency = '/emergency';
  static const String patientSettings = '/patientSettings';
  static const String patientSettingsNotifications =
      '/patientSettings/notifications';
  static const String patientSettingsPrivacy = '/patientSettings/privacy';
  static const String patientSettingsDarkMode = '/patientSettings/darkMode';
  static const String patientSettingsLanguage = '/patientSettings/language';
  static const String patientSettingsHelp = '/patientSettings/help';
  static const String patientProfile = '/patientProfile';
  static const String patientReports = '/patientReports';

  // Therapist routes
  static const String therapistHome = '/therapistHome';
  static const String appointmentRequests = '/appointmentRequests';
  static const String pendingSessions = '/pendingSessions';
  static const String therapistProfile = '/therapistProfile';
  static const String editTherapistProfile = '/editTherapistProfile';
  static const String therapistReports = '/therapistReports';
  static const String createReport = '/createReport';

  // patients list & detail
  static const String therapistPatients = '/therapistPatients';
  static const String therapistPatientDetail = '/therapistPatientDetail';

  // active sessions/chat list
  static const String activeSessions = '/activeSessions';
  static const String chatList = '/chatList';

  // Chat screens
  static const String patientChat = '/patientChat';
  static const String therapistChat = '/therapistChat';
}
