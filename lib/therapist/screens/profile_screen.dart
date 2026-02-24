import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: FaIcon(FontAwesomeIcons.user, size: 40, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              "Dr. Ahmed",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Clinical Psychologist"),
          ],
        ),
      ),
    );
  }
}
