import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../models/game_state.dart';
import '../services/audio_service.dart';
import '../services/auth_service.dart';
import '../models/player_stats.dart';
import '../services/user_profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    StepQuestAudioService.playTrack(MusicTrack.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerStats?>(
      stream: UserProfileService.watchCurrentUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF101018),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final player = snapshot.data ?? GameState.player;

        return Scaffold(
          backgroundColor: const Color(0xFF101018),
          appBar: AppBar(
            backgroundColor: const Color(0xFF101018),
            title: const Text("Profile"),
            actions: [
              IconButton(
                tooltip: 'Logout',
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await AuthService.signOut();

                  if (!context.mounted) return;

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
              ),
            ],
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

                const SizedBox(height: 24),
                const Text(
                  'Audio Settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const AudioControlPanel(),

                const SizedBox(height: 30),

                // ✏️ Button
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/edit-profile'),
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
      },
    );
  }

  Widget _achievement(String title) {
    return ListTile(
      leading: const Icon(Icons.emoji_events, color: Colors.amber),
      title: Text(title),
    );
  }
}

class AudioControlPanel extends StatefulWidget {
  const AudioControlPanel({super.key});

  @override
  State<AudioControlPanel> createState() => _AudioControlPanelState();
}

class _AudioControlPanelState extends State<AudioControlPanel> {
  double volume = StepQuestAudioService.volume;
  bool muted = StepQuestAudioService.isMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A27),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                muted ? Icons.volume_off : Icons.volume_up,
                color: Colors.greenAccent,
              ),
              const SizedBox(width: 10),
              const Text('Game Music'),
              const Spacer(),
              Switch(
                value: !muted,
                onChanged: (_) async {
                  await StepQuestAudioService.toggleMute();
                  setState(() {
                    muted = StepQuestAudioService.isMuted;
                  });
                },
              ),
            ],
          ),
          Slider(
            value: muted ? 0 : volume,
            min: 0,
            max: 1,
            divisions: 10,
            label: '${((muted ? 0 : volume) * 100).round()}%',
            onChanged: (value) async {
              await StepQuestAudioService.setVolume(value);
              setState(() {
                volume = value;
                muted = StepQuestAudioService.isMuted;
              });
            },
          ),
        ],
      ),
    );
  }
}
