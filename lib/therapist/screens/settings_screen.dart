import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text("Notifications"),
          ),
          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text("Privacy & Security"),
          ),
          ListTile(
            leading: Icon(Icons.dark_mode_outlined),
            title: Text("Dark Mode"),
          ),
        ],
      ),
    );
  }
}
