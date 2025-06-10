class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final int preparationTime;
  final int cookingTime;
  final String authorId;
  final DateTime createdAt;

  Recipe({
    this.id = '',
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.preparationTime,
    required this.cookingTime,
    required this.authorId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'steps': steps,
      'preparationTime': preparationTime,
      'cookingTime': cookingTime,
      'authorId': authorId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      ingredients: List<String>.from(map['ingredients'] as List<dynamic>),
      steps: List<String>.from(map['steps'] as List<dynamic>),
      preparationTime: map['preparationTime'] as int,
      cookingTime: map['cookingTime'] as int,
      authorId: map['authorId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
