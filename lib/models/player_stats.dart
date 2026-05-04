class PlayerStats {
  const PlayerStats({
    required this.name,
    required this.avatar,
    required this.level,
    required this.currentXp,
    required this.maxXp,
    required this.stepsToday,
    required this.stepGoal,
    required this.streakDays,
    required this.battlesWon,
    required this.totalSteps,
    required this.achievements,
    this.avatarPath = "default_avatar.png",
  });

  final String name;
  final String avatar;
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

  double get xpProgress => maxXp == 0 ? 0 : currentXp / maxXp;
  double get stepProgress => stepGoal == 0 ? 0 : stepsToday / stepGoal;

  factory PlayerStats.fromMap(Map<String, dynamic> data) {
    return PlayerStats(
      name: data['name'] ?? 'StepQuest Player',
      avatar: data['avatar'] ?? 'default_avatar',
      level: data['level'] ?? 1,
      currentXp: data['xp'] ?? 0,
      maxXp: data['maxXp'] ?? 100,
      stepsToday: data['stepsToday'] ?? 0,
      stepGoal: data['stepGoal'] ?? 10000,
      streakDays: data['currentStreak'] ?? data['streakDays'] ?? 0,
      battlesWon: data['battlesWon'] ?? 0,
      totalSteps: data['totalSteps'] ?? 0,
      achievements: List<String>.from(data['achievements'] ?? []),
      avatarPath: data['avatarPath'] ?? 'default_avatar.png',
    );
  }

  PlayerStats copyWith({
    String? name,
    String? avatar,
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
      avatar: avatar ?? this.avatar,
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