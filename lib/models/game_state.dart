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
    achievements: ['3-Day Streak'],
  );

  static void unlockAchievement(String achievement) {
    if (player.achievements.contains(achievement)) return;
    player = player.copyWith(
      achievements: [...player.achievements, achievement],
    );
  }

  static void checkAchievements() {
    if (player.battlesWon >= 1) {
      unlockAchievement('First Battle Won');
    }
    if (player.level >= 6) {
      unlockAchievement('Level 6 Reached');
    }
    if (player.stepsToday >= 10000) {
      unlockAchievement('10k Steps Completed');
    }
    if (player.streakDays >= 3) {
      unlockAchievement('3-Day Streak');
    }
  }

  static bool addXp(int amount) {
    int newXp = player.currentXp + amount;
    int newLevel = player.level;
    int maxXp = player.maxXp;
    bool leveledUp = false;

    // Level up logic
    if (newXp >= maxXp) {
      newXp = newXp - maxXp;
      newLevel++;
      maxXp += 500; // scaling difficulty
      leveledUp = true;
    }

    player = player.copyWith(currentXp: newXp, level: newLevel, maxXp: maxXp);
    checkAchievements();
    return leveledUp;
  }

  static void addBattleWin() {
    player = player.copyWith(battlesWon: player.battlesWon + 1);
    checkAchievements();
  }
}
