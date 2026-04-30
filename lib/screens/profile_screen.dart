import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              children: const [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.greenAccent,
                  child: Icon(Icons.person, size: 40, color: Colors.black),
                ),
                SizedBox(height: 12),
                Text(
                  "Darin",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text("Level 5 Warrior"),
              ],
            ),

            const SizedBox(height: 24),

            // 📊 Stats
            const StatCard(
              title: 'Total Steps',
              value: '120,000',
              icon: Icons.directions_walk,
              color: Colors.greenAccent,
            ),
            const StatCard(
              title: 'Battles Won',
              value: '12',
              icon: Icons.shield,
              color: Colors.redAccent,
            ),
            const StatCard(
              title: 'Achievements',
              value: '5',
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

            _achievement("First 10k Steps"),
            _achievement("3-Day Streak"),
            _achievement("First Battle Won"),

            const SizedBox(height: 30),

            // ✏️ Button
            ElevatedButton(
              onPressed: () {},
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
