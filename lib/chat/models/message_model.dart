import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String sender; // 'user' or 'ai'
  final String text;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map, String docId) {
    return MessageModel(
      id: docId,
      sender: map['sender'] ?? '',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
