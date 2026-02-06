import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';

class ChatItem {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;

  ChatItem({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
  });
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static final List<ChatItem> sampleChats = [
    ChatItem(
      id: 't1',
      name: 'Dr. Sara Khan',
      lastMessage: 'Please try the breathing exercise today.',
      time: '9:18 AM',
      unreadCount: 1,
    ),
    ChatItem(
      id: 't2',
      name: 'Mr. Ali Raza',
      lastMessage: 'Thanks for the update — well done!',
      time: 'Yesterday',
      unreadCount: 0,
    ),
    ChatItem(
      id: 't3',
      name: 'Therapist Team',
      lastMessage: 'Reminder: follow-up next week.',
      time: 'Mon',
      unreadCount: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.separated(
        itemCount: sampleChats.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final chat = sampleChats[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              radius: 26,
              child: Text(
                chat.name.split(' ').map((e) => e[0]).take(2).join(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              chat.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              chat.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chat.time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                if (chat.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${chat.unreadCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChatDetailScreen(chatId: chat.id, name: chat.name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
