import 'package:flutter/material.dart';

class Message {
  final String text;
  final bool isMe;
  final String time;

  Message({required this.text, required this.isMe, required this.time});
}

class ChatDetailScreen extends StatelessWidget {
  final String chatId;
  final String name;

  const ChatDetailScreen({super.key, required this.chatId, required this.name});

  static final List<Message> sampleMessages = [
    Message(
      text: 'Hi, how are you feeling today?',
      isMe: false,
      time: '9:00 AM',
    ),
    Message(
      text: 'I am a bit anxious, but trying breathing.',
      isMe: true,
      time: '9:02 AM',
    ),
    Message(
      text: 'Good. Try the paced breathing twice today.',
      isMe: false,
      time: '9:05 AM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Text(
                      name.split(' ').map((e) => e[0]).take(2).join(),
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
            Expanded(child: Text(name)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: sampleMessages.length,
                itemBuilder: (context, index) {
                  final msg = sampleMessages[index];
                  final alignment = msg.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start;
                  final bubbleColor = msg.isMe
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
                        msg.time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Input area (UI only)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Type a message (UI only)',
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
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
