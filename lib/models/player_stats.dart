class PlayerStats {
  const PlayerStats({
    required this.name,
    required this.level,
    required this.currentXp,
    required this.maxXp,
    required this.stepsToday,
    required this.stepGoal,
    required this.streakDays,
    required this.battlesWon,
    required this.totalSteps,
    required this.achievements,
    required this.avatarPath,
  });

  final String name;
  final int level;
  final int currentXp;
  final int maxXp;
  final int stepsToday;
  final int stepGoal;
  final int streakDays;
  final int battlesWon;
  final int totalSteps;
  final List<String> achievements;
  final String avatarPath;

  double get xpProgress => currentXp / maxXp;
  double get stepProgress => stepsToday / stepGoal;

  PlayerStats copyWith({
    String? name,
    int? level,
    int? currentXp,
    int? maxXp,
    int? stepsToday,
    int? stepGoal,
    int? streakDays,
    int? battlesWon,
    int? totalSteps,
    List<String>? achievements,
    String? avatarPath,
  }) {
    return PlayerStats(
      name: name ?? this.name,
      level: level ?? this.level,
      currentXp: currentXp ?? this.currentXp,
      maxXp: maxXp ?? this.maxXp,
      stepsToday: stepsToday ?? this.stepsToday,
      stepGoal: stepGoal ?? this.stepGoal,
      streakDays: streakDays ?? this.streakDays,
      battlesWon: battlesWon ?? this.battlesWon,
      totalSteps: totalSteps ?? this.totalSteps,
      achievements: achievements ?? this.achievements,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}
