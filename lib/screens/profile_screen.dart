import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../models/game_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final player = GameState.player;
    return Scaffold(
      backgroundColor: const Color(0xFF101018),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101018),
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            const SizedBox(height: 10),

            // 👤 Profile Header
            Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.greenAccent,
                  child: Icon(Icons.person, size: 40, color: Colors.black),
                ),
                const SizedBox(height: 12),
                Text(
                  player.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("Level ${player.level} Warrior"),
              ],
            ),

            const SizedBox(height: 24),

            // 📊 Stats
            StatCard(
              title: 'Total Steps',
              value: player.totalSteps.toString(),
              icon: Icons.directions_walk,
              color: Colors.greenAccent,
            ),
            StatCard(
              title: 'Battles Won',
              value: player.battlesWon.toString(),
              icon: Icons.shield,
              color: Colors.redAccent,
            ),
            StatCard(
              title: 'Achievements',
              value: '${player.achievements.length}',
              icon: Icons.emoji_events,
              color: Colors.amberAccent,
            ),

            const SizedBox(height: 24),

            // 🏅 Achievements
            const Text(
              "Achievements",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            for (final achievement in player.achievements)
              _achievement(achievement),

            const SizedBox(height: 30),

            // ✏️ Button
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _achievement(String title) {
    return ListTile(
      leading: const Icon(Icons.emoji_events, color: Colors.amber),
      title: Text(title),
    );
  }
}
