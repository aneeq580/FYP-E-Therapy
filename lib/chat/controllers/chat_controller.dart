import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:get/get.dart';

/// Handles a single chat room's message stream and sending logic.
///
/// `chatRoomId` is an observable because it may be generated after a session is
/// created; the controller will begin listening once a non-empty ID appears.
class ChatController extends GetxController {
  /// currentUserName is reactive so that we can pick up any changes (e.g. after
  /// session controller loads the name later).
  ChatController({
    required this.chatRoomId,
    required this.currentUserId,
    required RxString currentUserName,
  }) : _currentUserName = currentUserName;

  final RxString chatRoomId;
  final String currentUserId;
  final RxString _currentUserName;

  String get currentUserName => _currentUserName.value;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final messages = <ChatMessage>[].obs;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;

  @override
  void onInit() {
    super.onInit();
    // when roomId changes, restart listener
    ever<String>(chatRoomId, (id) {
      _sub?.cancel();
      messages.clear();
      if (id.isNotEmpty) _listen(id);
    });
  }

  void _listen(String roomId) {
    _sub = _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snap) {
          final list = snap.docs.map((doc) {
            final data = doc.data();
            return ChatMessage(
              text: data['text'] as String? ?? '',
              createdAt:
                  (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
              user: ChatUser(
                id: data['senderId'] as String? ?? '',
                firstName: data['senderName'] as String? ?? '',
              ),
            );
          }).toList();
          messages.value = list;
        });
  }

  Future<void> sendMessage(String text) async {
    if (chatRoomId.value.isEmpty || text.trim().isEmpty) return;
    final doc = _firestore
        .collection('chats')
        .doc(chatRoomId.value)
        .collection('messages');
    await doc.add({
      'text': text.trim(),
      'senderId': currentUserId,
      'senderName': currentUserName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
