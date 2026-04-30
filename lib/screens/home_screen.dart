import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/xp_progress_bar.dart';
import '../models/player_stats.dart';

class HomeScreen extends StatelessWidget {
  final PlayerStats player = PlayerStats(
    name: 'Hero',
    level: 5,
    xp: 1200,
    xpToNextLevel: 2000,
    health: 80,
    maxHealth: 100,
    steps: 3500,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        children: [
          StatCard(player: player),
          XPProgressBar(
            currentXP: player.xp,
            xpToNextLevel: player.xpToNextLevel,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/quest'),
                child: Text('Quest'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/battle'),
                child: Text('Battle'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/profile'),
                child: Text('Profile'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
