class Quest {
  const Quest({
    required this.id,
    required this.title,
    required this.goal,
    required this.rewardXp,
    required this.completed,
    required this.claimed,
  });

  final String id;
  final String title;
  final int goal;
  final int rewardXp;
  final bool completed;
  final bool claimed;

  factory Quest.fromMap(String id, Map<String, dynamic> data) {
    return Quest(
      id: id,
      title: data['title'] ?? 'Untitled Quest',
      goal: data['goal'] ?? 0,
      rewardXp: data['rewardXp'] ?? 0,
      completed: data['completed'] ?? false,
      claimed: data['claimed'] ?? false,
    );
  }
}