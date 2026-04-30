import 'package:flutter/material.dart';

import '../models/game_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController stepsController;

  @override
  void initState() {
    super.initState();
    final player = GameState.player;

    nameController = TextEditingController(text: player.name);
    stepsController = TextEditingController(text: player.totalSteps.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    stepsController.dispose();
    super.dispose();
  }

  void saveProfile() {
    final totalSteps = int.tryParse(stepsController.text.trim());

    GameState.player = GameState.player.copyWith(
      name: nameController.text.trim().isEmpty
          ? GameState.player.name
          : nameController.text.trim(),
      totalSteps: totalSteps ?? GameState.player.totalSteps,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile updated')));

    Navigator.pushReplacementNamed(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101018),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101018),
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Player Name',
                filled: true,
                fillColor: const Color(0xFF1A1A27),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: stepsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Total Steps',
                filled: true,
                fillColor: const Color(0xFF1A1A27),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
