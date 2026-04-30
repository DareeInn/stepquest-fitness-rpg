import 'package:flutter/material.dart';

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
            _statCard("🔥 Total Steps", "120,000"),
            _statCard("⚔️ Battles Won", "12"),
            _statCard("🏆 Achievements", "5"),

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

  Widget _statCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A27),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
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
