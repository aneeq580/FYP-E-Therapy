import 'dart:async';

import 'package:flutter/material.dart';
import '../../core/widgets/patient_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_therapy/controllers/chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_therapy/models/chat_message.dart';

/// Detailed chat screen showing messages for a specific appointment session.
class ChatDetailScreen extends StatefulWidget {
  final String sessionId;
  final String name;

  const ChatDetailScreen({
    super.key,
    required this.sessionId,
    required this.name,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late final ChatController chatController;
  final TextEditingController _textController = TextEditingController();
  User? currentUser;

  /// keeps track of current time so countdown updates every second
  final Rx<DateTime> _now = DateTime.now().obs;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // reuse existing controller if previously created (e.g. therapist/patient switching)
    if (Get.isRegistered<ChatController>()) {
      chatController = Get.find<ChatController>();
    } else {
      chatController = Get.put(ChatController());
    }
    chatController.bindSession(widget.sessionId);
    currentUser = FirebaseAuth.instance.currentUser;

    // start timer to update _now every second while session is active
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      _now.value = DateTime.now();
    });
  }

  void _send() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    final msg = ChatMessage(
      id: '',
      senderId: currentUser?.uid ?? '',
      text: text,
      timestamp: Timestamp.now(),
    );
    await chatController.sendMessage(widget.sessionId, msg);
    _textController.clear();
  }

  @override
  void dispose() {
    _textController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PatientAppBar(
        titleWidget: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Text(
                      widget.name.split(' ').map((e) => e[0]).take(2).join(),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(widget.name)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              final appt = chatController.session.value;
              if (appt != null && appt.isActive) {
                final remaining = appt.endTime.toDate().difference(_now.value);
                if (!remaining.isNegative) {
                  return Container(
                    width: double.infinity,
                    color: Colors.yellow.shade200,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Time remaining: ${remaining.inMinutes.remainder(60)} min ${remaining.inSeconds.remainder(60)} sec',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  );
                }
              }
              return const SizedBox.shrink();
            }),
            Expanded(
              child: Obx(() {
                final msgs = chatController.messages;
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: msgs.length,
                  itemBuilder: (context, index) {
                    final msg = msgs[index];
                    final isMe =
                        currentUser != null && msg.senderId == currentUser!.uid;
                    final alignment = isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start;
                    final bubbleColor = isMe
                        ? Colors.blue.shade100
                        : Colors.grey.shade200;
                    return Column(
                      crossAxisAlignment: alignment,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: bubbleColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 280),
                            child: Text(msg.text),
                          ),
                        ),
                        Text(
                          msg.timestamp
                              .toDate()
                              .toLocal()
                              .toString()
                              .split(' ')[1]
                              .split('.')[0],
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),

            // Input area
            Obx(() {
              final active = chatController.session.value?.isActive ?? false;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        onSubmitted: active ? (_) => _send() : null,
                        enabled: active,
                        decoration: InputDecoration(
                          hintText: active ? 'Type a message' : 'Chat ended',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: active ? _send : null,
                      child: CircleAvatar(
                        backgroundColor: active
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        child: const FaIcon(
                          FontAwesomeIcons.paperPlane,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
