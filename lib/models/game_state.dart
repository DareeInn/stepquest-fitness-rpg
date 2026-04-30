import 'player_stats.dart';

class GameState {
  static PlayerStats player = const PlayerStats(
    name: "Darin",
    level: 5,
    currentXp: 1200,
    maxXp: 1500,
    stepsToday: 6542,
    stepGoal: 10000,
    streakDays: 3,
    battlesWon: 12,
    totalSteps: 120000,
  );

  static void addXp(int amount) {
    int newXp = player.currentXp + amount;
    int newLevel = player.level;
    int maxXp = player.maxXp;

    // Level up logic
    if (newXp >= maxXp) {
      newXp = newXp - maxXp;
      newLevel++;
      maxXp += 500; // scaling difficulty
    }

    player = player.copyWith(currentXp: newXp, level: newLevel, maxXp: maxXp);
  }

  static void addBattleWin() {
    player = player.copyWith(battlesWon: player.battlesWon + 1);
  }
}
