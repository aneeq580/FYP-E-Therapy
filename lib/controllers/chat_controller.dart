import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/chat_message.dart';
import '../models/appointment_model.dart';
import '../services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Controller for a particular chat (appointment session).
class ChatController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();

  /// messages in the current chat
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final Rxn<AppointmentModel> session = Rxn();

  String? currentSessionId;

  void bindSession(String sessionId) {
    // always rebind so that therapists/patients switching views never see stale data
    currentSessionId = sessionId;
    messages.bindStream(_chatService.getMessages(sessionId));
    // log updates for debugging
    messages.listen((list) {
      debugPrint(
        'ChatController: [$currentSessionId] message count=${list.length}',
      );
    });

    // also listen to appointment details
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(sessionId)
        .snapshots()
        .map(
          (snap) => snap.exists
              ? AppointmentModel.fromMap(
                  snap.data() as Map<String, dynamic>,
                  snap.id,
                )
              : null,
        )
        .listen((model) {
          session.value = model;
        });
  }

  Future<void> sendMessage(String sessionId, ChatMessage msg) async {
    await _chatService.sendMessage(sessionId, msg);
  }
}
