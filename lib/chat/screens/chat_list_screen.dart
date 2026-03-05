import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/appointment_controller.dart';
import '../screens/chat_screen.dart';
import '../../core/constants/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';

/// A WhatsApp‑style conversation list.  Shows every session that has a
/// `chatRoomId` and involves the current user (patient or therapist).
/// Tapping an item opens the corresponding chat screen.  If there are no
/// chats yet, an empty‑state message is shown.
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key, required this.isTherapist});

  final bool isTherapist;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AppointmentController>()) {
      Get.put(AppointmentController());
    }
    final ctrl = Get.find<AppointmentController>();

    // choose stream depending on role
    // We don't rely on a single stream for therapists because
    // `therapistUpcomingAppointments` drops completed sessions. Compute
    // the union of upcoming + completed (and optionally cancelled) so that
    // chats remain visible after the session ends.
    // Patient side already uses `patientAppointments` which includes every
    // status.

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: Obx(() {
        final sessions = isTherapist
            ? [
                ...ctrl.therapistUpcomingAppointments,
                ...ctrl.therapistCompletedAppointments,
                // you could also include cancelled/other statuses if desired
              ]
            : ctrl.patientAppointments;

        final filtered = sessions
            .where((s) => s.chatRoomId != null && s.chatRoomId!.isNotEmpty)
            .toList();
        if (filtered.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spacingLarge),
              child: Text(
                'No conversations yet. Start a session to chat.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyTextSecondary.copyWith(fontSize: 16),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final session = filtered[index];
            return ChatListItem(session: session, isTherapist: isTherapist);
          },
        );
      }),
    );
  }
}

/// List tile that previews the most recent message and opens chat when tapped.
class ChatListItem extends StatelessWidget {
  const ChatListItem({
    super.key,
    required this.session,
    required this.isTherapist,
  });

  final dynamic session; // AppointmentModel
  final bool isTherapist;

  @override
  Widget build(BuildContext context) {
    final partnerName = isTherapist
        ? session.patientName
        : session.therapistName;
    final room = session.chatRoomId as String;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(room)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snap) {
        String subtitle = 'Tap to chat';
        String time = '';
        if (snap.hasData && snap.data!.docs.isNotEmpty) {
          final msg = snap.data!.docs.first.data();
          subtitle = msg['text'] as String? ?? '';
          final ts = msg['createdAt'] as Timestamp?;
          if (ts != null) {
            time = DateFormat('h:mm a').format(ts.toDate());
          }
        }

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingMedium,
            vertical: AppSizes.spacingSmall,
          ),
          leading: CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Text(
              partnerName.isNotEmpty ? partnerName[0] : '?',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(partnerName.isNotEmpty ? partnerName : 'Unknown'),
          subtitle: Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: time.isNotEmpty
              ? Text(time, style: TextStyle(fontSize: 12))
              : null,
          onTap: () {
            Get.to(
              () => ChatScreen(sessionId: session.id, isTherapist: isTherapist),
            );
          },
        );
      },
    );
  }
}
