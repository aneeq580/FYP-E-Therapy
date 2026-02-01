import 'package:flutter/material.dart';

class BookSessionScreen extends StatelessWidget {
  const BookSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Session')),
      body: const Center(
        child: Text('Book Session Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
