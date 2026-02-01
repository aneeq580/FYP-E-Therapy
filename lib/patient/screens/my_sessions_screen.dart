import 'package:flutter/material.dart';

class MySessionsScreen extends StatelessWidget {
  const MySessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sessions'),
      ),
      body: const Center(
        child: Text(
          'My Sessions Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

