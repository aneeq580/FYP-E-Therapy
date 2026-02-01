import 'package:flutter/material.dart';

class TherapistListScreen extends StatelessWidget {
  const TherapistListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Therapists')),
      body: const Center(
        child: Text('Therapists Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
