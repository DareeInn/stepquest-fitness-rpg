import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _go(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StepQuest Home')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Level 5 Warrior', style: TextStyle(fontSize: 28)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _go(context, '/quest'),
              child: const Text('Start Quest'),
            ),
            ElevatedButton(
              onPressed: () => _go(context, '/battle'),
              child: const Text('Battle'),
            ),
            ElevatedButton(
              onPressed: () => _go(context, '/profile'),
              child: const Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
