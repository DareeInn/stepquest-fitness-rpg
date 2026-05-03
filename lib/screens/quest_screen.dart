import 'package:flutter/material.dart';

import '../models/game_state.dart';
import '../models/quest.dart';
import '../services/audio_service.dart';
import '../services/quest_service.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  Quest? selectedQuest;

  @override
  void initState() {
    super.initState();
    StepQuestAudioService.playTrack(MusicTrack.dashboard);
    QuestService.createStarterQuestsIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    final player = GameState.player;
    final steps = player.stepsToday;

    return Scaffold(
      backgroundColor: const Color(0xFF101018),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101018),
        title: const Text("Daily Quests"),
      ),
      body: StreamBuilder<List<Quest>>(
        stream: QuestService.watchQuests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final quests = snapshot.data ?? [];

          if (quests.isEmpty) {
            return const Center(child: Text('No quests available yet.'));
          }

          selectedQuest ??= quests.first;

          final selected = selectedQuest!;
          final progress = selected.goal == 0 ? 0.0 : steps / selected.goal;
          final canClaim = steps >= selected.goal && !selected.claimed;

          return Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                const SizedBox(height: 10),
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
                            "${(progress * 100).clamp(0, 100).toInt()}%",
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A27),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      _infoRow("Selected Quest", selected.title),
                      const SizedBox(height: 8),
                      _infoRow("Goal", "${selected.goal} steps"),
                      const SizedBox(height: 8),
                      _infoRow("Current", "$steps steps"),
                      const SizedBox(height: 8),
                      _infoRow("Reward", "${selected.rewardXp} XP"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      for (final quest in quests) _questItem(quest, steps),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: canClaim
                      ? () async {
                          await QuestService.claimQuestReward(selected);

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Quest complete! +${selected.rewardXp} XP claimed.',
                              ),
                            ),
                          );

                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white12,
                    disabledForegroundColor: Colors.white38,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 40,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    selected.claimed
                        ? "Reward Claimed"
                        : canClaim
                        ? "Claim Reward"
                        : "Quest Not Complete",
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Return to Home'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _questItem(Quest quest, int steps) {
    final completed = steps >= quest.goal;

    return ListTile(
      leading: Icon(
        quest.claimed
            ? Icons.verified
            : completed
            ? Icons.check_circle
            : Icons.radio_button_unchecked,
        color: quest.claimed || completed ? Colors.greenAccent : Colors.white30,
      ),
      title: Text(quest.title),
      subtitle: Text('${quest.goal} steps • ${quest.rewardXp} XP'),
      selected: selectedQuest?.id == quest.id,
      onTap: () {
        setState(() {
          selectedQuest = quest;
        });
      },
      trailing: selectedQuest?.id == quest.id
          ? const Icon(Icons.arrow_right, color: Colors.greenAccent)
          : null,
    );
  }
}
