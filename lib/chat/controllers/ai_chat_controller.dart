import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_therapy/chat/models/message_model.dart';
import 'package:get/get.dart';
// import '../../models/message_model.dart';
import '../services/gemini_chat_service.dart';

class AiChatController extends GetxController {
  final GeminiChatService _chatService = GeminiChatService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = false.obs;

  late String userId;

  @override
  void onInit() {
    super.onInit();
    userId = _auth.currentUser?.uid ?? 'unknown_user';
    _listenToMessages();
  }

  void _listenToMessages() {
    _firestore
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
          messages.value = snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
              .toList();
          _scrollToBottom();
        });
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    textController.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      isLoading.value = true;

      // 1. Save user message to Firestore
      final userMsgRef = _firestore
          .collection('chats')
          .doc(userId)
          .collection('messages')
          .doc();
      final userMessage = MessageModel(
        id: userMsgRef.id,
        sender: 'user',
        text: text,
        timestamp: DateTime.now(),
      );

      await _firestore.collection('chats').doc(userId).set({
        'userId': userId,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await userMsgRef.set(userMessage.toMap());

      // 2. Prepare previous messages context for AI
      // Get the last 10 messages for context
      final recentMessages = messages.length > 10
          ? messages.sublist(messages.length - 10)
          : messages;

      final previousContext = recentMessages
          .map((m) => {'sender': m.sender, 'text': m.text})
          .toList();

      // 3. Call Cloud Function
      final aiReply = await _chatService.sendMessageToGemini(
        text,
        previousContext,
      );

      // 4. Save AI reply to Firestore
      final aiMsgRef = _firestore
          .collection('chats')
          .doc(userId)
          .collection('messages')
          .doc();
      final aiMessage = MessageModel(
        id: aiMsgRef.id,
        sender: 'ai',
        text: aiReply,
        timestamp: DateTime.now(),
      );

      await aiMsgRef.set(aiMessage.toMap());
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent +
              200, // add some extra buffer
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void clearMessages() {
    messages.clear();
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
