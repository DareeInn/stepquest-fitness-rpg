import 'package:flutter/material.dart';
import '../models/game_state.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  int selectedQuest = 0;
  // Track which quests have been claimed
  final Set<int> claimedQuests = {};

  @override
  Widget build(BuildContext context) {
    final player = GameState.player;
    final steps = player.stepsToday;
    final goal = player.stepGoal;
    final progress = steps / goal;

    return Scaffold(
      backgroundColor: const Color(0xFF101018),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101018),
        title: const Text("Daily Quest"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            // 🔵 Circular Progress
            SizedBox(
              height: 180,
              width: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    strokeWidth: 12,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.greenAccent,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${(progress * 100).toInt()}%",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Completed"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 📊 Goal Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A27),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  _infoRow("Goal", "$goal steps"),
                  const SizedBox(height: 8),
                  _infoRow("Current", "$steps steps"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // ✅ Quest List
            Expanded(
              child: ListView(
                children: [
                  _questItem(0, "Walk 5,000 steps", steps >= 5000),
                  _questItem(1, "Reach 10,000 steps", steps >= 10000),
                  _questItem(2, "Burn 300 calories", false),
                ],
              ),
            ),
            // 🎁 Claim Button
            ElevatedButton(
              onPressed: () {
                GameState.addXp(100);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Quest complete! +100 XP added.'),
                  ),
                );
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 40,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                claimedQuests.contains(selectedQuest)
                    ? "Reward Claimed"
                    : "Claim Reward",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
              ),
              child: const Text('Return to Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _questItem(int index, String title, bool completed) {
    return ListTile(
      leading: Icon(
        completed ? Icons.check_circle : Icons.radio_button_unchecked,
        color: completed ? Colors.greenAccent : Colors.white30,
      ),
      title: Text(title),
      selected: selectedQuest == index,
      onTap: () {
        setState(() {
          selectedQuest = index;
          // Allow claiming again if switching to a new quest
        });
      },
      trailing: selectedQuest == index
          ? const Icon(Icons.arrow_right, color: Colors.greenAccent)
          : null,
    );
  }

  bool canClaimReward(int quest, int steps) {
    if (quest == 0 && steps >= 5000) return true;
    if (quest == 1 && steps >= 10000) return true;
    // Add more quest logic as needed
    return false;
  }
}
