import 'package:flutter/material.dart';

class BattleScreen extends StatelessWidget {
  const BattleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Battle Arena')),
      body: const Center(child: Text('Battle Screen')),
    );
  }
}
