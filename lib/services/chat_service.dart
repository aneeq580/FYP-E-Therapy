import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ChatMessage>> getMessages(String sessionId) {
    return _firestore
        .collection('appointments')
        .doc(sessionId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => ChatMessage.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> sendMessage(String sessionId, ChatMessage msg) async {
    await _firestore
        .collection('appointments')
        .doc(sessionId)
        .collection('messages')
        .add(msg.toMap());
  }
}
