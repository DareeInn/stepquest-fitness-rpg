class PlayerStats {
  final String name;
  final int level;
  final int xp;
  final int xpToNextLevel;
  final int health;
  final int maxHealth;
  final int steps;

  PlayerStats({
    required this.name,
    required this.level,
    required this.xp,
    required this.xpToNextLevel,
    required this.health,
    required this.maxHealth,
    required this.steps,
  });
}
