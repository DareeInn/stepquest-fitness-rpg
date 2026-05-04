class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;

  factory Achievement.fromMap(String id, Map<String, dynamic> data) {
    return Achievement(
      id: id,
      title: data['title'] ?? 'Achievement',
      description: data['description'] ?? '',
    );
  }
}