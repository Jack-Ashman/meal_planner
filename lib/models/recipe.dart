class Recipe {
  Recipe({
    required this.id,
    required this.title,
    this.imagePath,
    required this.steps,
  });

  final String id;
  final String title;
  final String? imagePath;
  final List<String> steps;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'imagePath': imagePath,
    'steps': steps,
  };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'] as String,
    title: json['title'] as String,
    imagePath: json['imagePath'] as String?,
    steps: List<String>.from(json['steps'] as List),
  );
}
