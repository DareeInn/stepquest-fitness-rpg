import 'package:flutter/material.dart';

class QuestScreen extends StatelessWidget {
  const QuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Quest')),
      body: const Center(child: Text('Step Tracker / Quest Screen')),
    );
  }
}
