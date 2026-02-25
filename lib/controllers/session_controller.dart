import 'package:get/get.dart';

import '../models/session_model.dart';
import '../services/session_service.dart';

/// Controller to coordinate session-related state for patient views.
///
/// Currently manages tab index for the My Sessions screen and exposes
/// convenience getters that delegate to [SessionService].
class SessionController extends GetxController {
  final SessionService _sessionService = Get.find<SessionService>();

  /// Index for the 4 tabs: Pending | Upcoming | Completed | Cancelled
  final RxInt currentTabIndex = 0.obs;

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  RxList<SessionModel> getPendingSessions() {
    return _sessionService.getMySessions(SessionStatus.pending);
  }

  RxList<SessionModel> getUpcomingSessions() {
    return _sessionService.getMySessions(SessionStatus.upcoming);
  }

  RxList<SessionModel> getCompletedSessions() {
    return _sessionService.getMySessions(SessionStatus.completed);
  }

  RxList<SessionModel> getCancelledSessions() {
    return _sessionService.getMySessions(SessionStatus.cancelled);
  }
}
