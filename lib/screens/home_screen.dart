import 'package:flutter/material.dart';
import '../widgets/xp_progress_bar.dart';
import '../models/game_state.dart';
import '../models/player_stats.dart';
import '../services/audio_service.dart';
import '../services/user_profile_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        double xpProgress = player.xpProgress;
        double stepProgress = player.stepProgress;

        return Scaffold(
          backgroundColor: const Color(0xFF101018),
          appBar: AppBar(
            backgroundColor: const Color(0xFF101018),
            title: const Text('StepQuest'),
            actions: [
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/profile'),
                icon: const Icon(Icons.person),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(18),
            child: ListView(
              children: [
                Text(
                  'Welcome back, ${player.name}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your steps power your RPG adventure.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 24),
                _buildHeroCard(player),
                const SizedBox(height: 18),
                XpProgressBar(
                  title: 'XP Progress',
                  icon: Icons.auto_awesome,
                  valueText: '${player.currentXp} / ${player.maxXp} XP',
                  progress: xpProgress,
                  color: Colors.purpleAccent,
                ),
                const SizedBox(height: 14),
                XpProgressBar(
                  title: 'Daily Steps',
                  icon: Icons.directions_walk,
                  valueText: '${player.stepsToday} / ${player.stepGoal} steps',
                  progress: stepProgress,
                  color: Colors.greenAccent,
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        context,
                        label: 'Start Quest',
                        icon: Icons.flag,
                        route: '/quest',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        context,
                        label: 'Battle',
                        icon: Icons.sports_martial_arts,
                        route: '/battle',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0xFF171724),
            selectedItemColor: Colors.greenAccent,
            unselectedItemColor: Colors.white60,
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            onTap: (index) {
              if (index == 1) Navigator.pushNamed(context, '/quest');
              if (index == 2) Navigator.pushNamed(context, '/battle');
              if (index == 3) Navigator.pushNamed(context, '/profile');
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Quests'),
              BottomNavigationBarItem(
                icon: Icon(Icons.shield),
                label: 'Battle',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroCard(PlayerStats player) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF11998E), Color(0xFF2F6BFF)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Level ${player.level} Warrior',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '🔥 ${player.streakDays}-day streak  •  ⚔️ ${player.battlesWon} battles won',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String route,
  }) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.pushNamed(context, route),
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
