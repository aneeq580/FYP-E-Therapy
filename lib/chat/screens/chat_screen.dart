import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chat_controller.dart';
import '../controllers/session_controller.dart';
import '../../controllers/appointment_controller.dart';
import '../../core/constants/colors.dart';
import '../../patient/widgets/rating_dialog.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required this.sessionId,
    required this.isTherapist,
  });

  final String sessionId;
  final bool isTherapist;

  @override
  Widget build(BuildContext context) {
    // Session controller keeps the appointment state + countdown
    final sessionCtrl = Get.put(
      SessionController(sessionId: sessionId, isTherapist: isTherapist),
      tag: sessionId,
    );

    // after sessionCtrl initializes chatRoomId may be empty for an instant, but
    // chatCtrl can listen to changes via the RxString passed below.
    final user = FirebaseAuth.instance.currentUser!;
    final chatCtrl = Get.put(
      ChatController(
        chatRoomId: sessionCtrl.chatRoomId,
        currentUserId: user.uid,
        currentUserName: isTherapist
            ? sessionCtrl.therapistName
            : sessionCtrl.patientName,
      ),
      tag: sessionId,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isTherapist ? AppColors.therapistPrimary : AppColors.primary,
        foregroundColor: Colors.white,
        title: Obx(() {
          final name = sessionCtrl.partnerName;
          if (name.isEmpty) return const Text('Chat');
          return Text('Chat with $name');
        }),
      ),
      body: Column(
        children: [
          // countdown timer / status message
          Obx(() {
            final rem = sessionCtrl.remaining.value;
            if (sessionCtrl.status.value == 'completed') {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Session Ended',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            }

            if (!sessionCtrl.chatEnabled) {
              return Container(
                width: double.infinity,
                color: (isTherapist ? AppColors.therapistPrimary : AppColors.primary).withOpacity(0.1),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Text(
                    'Waiting for therapist to start...',
                    style: TextStyle(
                      color: isTherapist ? AppColors.therapistPrimary : AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }

            final minutes = rem.inMinutes
                .remainder(60)
                .toString()
                .padLeft(2, '0');
            final seconds = rem.inSeconds
                .remainder(60)
                .toString()
                .padLeft(2, '0');
            return Container(
              width: double.infinity,
              color: (isTherapist ? AppColors.therapistPrimary : AppColors.primary).withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Remaining: $minutes:$seconds',
                    style: TextStyle(
                      color: isTherapist ? AppColors.therapistPrimary : AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (rem.inSeconds <= 300 && rem.inSeconds > 0) ...[
                    const SizedBox(height: 6),
                    ElevatedButton.icon(
                      onPressed: () => sessionCtrl.extendSession(),
                      icon: const Icon(Icons.add_alarm, size: 16),
                      label: const Text('Extend +5 mins'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isTherapist ? AppColors.therapistPrimary : AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
          // action button row (Complete / Leave).  Compare to the old
          // implementation: the button previously only appeared when
          // `status == 'started'`, which meant an appointment with the
          // legacy 'active' status or one still syncing might show a disabled
          // placeholder.  We now rely on `chatEnabled` which covers both
          // 'started' and 'active' and guarantees the control is present as
          // soon as the therapist hits Start.
          Obx(() {
            if (!sessionCtrl.chatEnabled) return const SizedBox.shrink();
            if (isTherapist) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.therapistPrimary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // therapist may finish early
                    Get.find<AppointmentController>().completeAppointment(
                      sessionId,
                    );
                  },
                  child: const Text('Complete Session'),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    // leaving also ends the session on both sides
                    await Get.find<AppointmentController>().completeAppointment(
                      sessionId,
                    );
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => RatingDialog(therapistId: sessionCtrl.therapistId.value),
                    );
                  },
                  child: const Text('Leave Session'),
                ),
              );
            }
          }),
          Expanded(
            child: Obx(() {
              return DashChat(
                messages: chatCtrl.messages.toList(),
                currentUser: ChatUser(id: user.uid),
                onSend: (ChatMessage msg) {
                  chatCtrl.sendMessage(msg.text);
                },
                messageOptions: MessageOptions(
                  currentUserContainerColor: isTherapist
                      ? AppColors.therapistPrimary
                      : AppColors.primary,
                  currentUserTextColor: Colors.white,
                  containerColor: Colors.grey.shade200,
                  textColor: Colors.black,
                ),
                inputOptions: InputOptions(
                  inputDecoration: InputDecoration(
                    hintText: 'Type a message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  sendButtonBuilder: (onSend) => IconButton(
                    icon: Icon(
                      Icons.send_rounded,
                      color: isTherapist
                          ? AppColors.therapistPrimary
                          : AppColors.primary,
                    ),
                    onPressed: onSend,
                  ),
                  // dash_chat_2 uses `inputDisabled` rather than `enabled`
                  inputDisabled: !(sessionCtrl.chatEnabled &&
                      sessionCtrl.remaining.value > Duration.zero),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
