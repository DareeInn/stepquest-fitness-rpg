import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../services/audio_service.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class Quest {
  final String title;
  final String description;
  final int rewardXp;
  final bool completed;
  final bool claimed;

  Quest({
    required this.title,
    required this.description,
    required this.rewardXp,
    required this.completed,
    required this.claimed,
  });

  Quest copyWith({
    String? title,
    String? description,
    int? rewardXp,
    bool? completed,
    bool? claimed,
  }) {
    return Quest(
      title: title ?? this.title,
      description: description ?? this.description,
      rewardXp: rewardXp ?? this.rewardXp,
      completed: completed ?? this.completed,
      claimed: claimed ?? this.claimed,
    );
  }
}

class _QuestScreenState extends State<QuestScreen> {
  List<Quest> quests = [];
  final List<Quest> questTemplates = [
    Quest(
      title: "Walk 5,000 steps",
      description: "Take at least 5,000 steps today.",
      rewardXp: 100,
      completed: false,
      claimed: false,
    ),
    Quest(
      title: "Win 1 battle",
      description: "Win a battle today.",
      rewardXp: 120,
      completed: false,
      claimed: false,
    ),
    Quest(
      title: "Earn 200 XP",
      description: "Earn at least 200 XP today.",
      rewardXp: 150,
      completed: false,
      claimed: false,
    ),
    Quest(
      title: "Complete daily login",
      description: "Log in today to claim your reward!",
      rewardXp: 50,
      completed: false,
      claimed: false,
    ),
    Quest(
      title: "Burn 300 calories",
      description: "Burn at least 300 calories today.",
      rewardXp: 80,
      completed: false,
      claimed: false,
    ),
    Quest(
      title: "Reach 10,000 steps",
      description: "Take at least 10,000 steps today.",
      rewardXp: 200,
      completed: false,
      claimed: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    StepQuestAudioService.playTrack(MusicTrack.dashboard);
    final player = GameState.player;
    quests = [
      questTemplates[0].copyWith(completed: player.stepsToday >= 5000),
      questTemplates[1].copyWith(completed: player.battlesWon >= 1),
      questTemplates[2].copyWith(completed: player.currentXp >= 200),
      questTemplates[3].copyWith(completed: true), // Daily login
    ];
  }

  void _claimQuest(int index) {
    setState(() {
      quests[index] = quests[index].copyWith(claimed: true);
    });
    final leveledUp = GameState.addXp(quests[index].rewardXp);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          leveledUp
              ? 'Quest complete! +${quests[index].rewardXp} XP and level up!'
              : 'Quest complete! +${quests[index].rewardXp} XP added.',
        ),
      ),
    );
    // Replace with a new random quest
    setState(() {
      quests[index] = _generateRandomQuest();
    });
    Navigator.pushReplacementNamed(context, '/home');
  }

  Quest _generateRandomQuest() {
    final player = GameState.player;
    final currentTitles = quests.map((q) => q.title).toSet();
    final available = questTemplates.where((q) => !currentTitles.contains(q.title)).toList();
    if (available.isEmpty) return questTemplates[0];
    final random = available[(available.length * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000).floor()];
    // Update completed status based on player state
    if (random.title == "Walk 5,000 steps") {
      return random.copyWith(completed: player.stepsToday >= 5000, claimed: false);
    } else if (random.title == "Win 1 battle") {
      return random.copyWith(completed: player.battlesWon >= 1, claimed: false);
    } else if (random.title == "Earn 200 XP") {
      return random.copyWith(completed: player.currentXp >= 200, claimed: false);
    } else if (random.title == "Complete daily login") {
      return random.copyWith(completed: true, claimed: false);
    } else if (random.title == "Burn 300 calories") {
      return random.copyWith(completed: false, claimed: false);
    } else if (random.title == "Reach 10,000 steps") {
      return random.copyWith(completed: player.stepsToday >= 10000, claimed: false);
    }
    return random.copyWith(claimed: false);
  }

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
        title: const Text("Daily Quests"),
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
              child: ListView.builder(
                itemCount: quests.length,
                itemBuilder: (context, index) {
                  final quest = quests[index];
                  return Card(
                    color: const Color(0xFF1A1A27),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        quest.completed
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: quest.completed
                            ? Colors.greenAccent
                            : Colors.white30,
                      ),
                      title: Text(quest.title),
                      subtitle: Text(quest.description),
                      trailing: quest.claimed
                          ? const Icon(
                              Icons.verified,
                              color: Colors.greenAccent,
                            )
                          : ElevatedButton(
                              onPressed: quest.completed && !quest.claimed
                                  ? () => _claimQuest(index)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent,
                                foregroundColor: Colors.black,
                              ),
                              child: Text('Claim +${quest.rewardXp} XP'),
                            ),
                    ),
                  );
                },
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
}
