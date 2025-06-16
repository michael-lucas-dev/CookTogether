class Recipe {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final int? preparationTime;
  final int? cookingTime;
  final String authorId;
  final DateTime createdAt;
  final List<String>? utensils;

  Recipe({
    this.id = '',
    required this.title,
    this.description,
    this.imageUrl,
    required this.ingredients,
    required this.steps,
    this.preparationTime,
    this.cookingTime,
    required this.authorId,
    required this.createdAt,
    this.utensils,
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
      'utensils': utensils,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      imageUrl: map['imageUrl'] as String?,
      ingredients: List<String>.from(map['ingredients'] as List<dynamic>),
      steps: List<String>.from(map['steps'] as List<dynamic>),
      preparationTime: map['preparationTime'] as int?,
      cookingTime: map['cookingTime'] as int?,
      authorId: map['authorId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      utensils: List<String>.from(map['utensils'] as List<dynamic>? ?? []),
    );
  }

  Recipe copyWith({
    String? id,
    String? imageUrl,
    String? title,
    String? description,
    List<String>? ingredients,
    List<String>? steps,
    int? preparationTime,
    int? cookingTime,
    String? authorId,
    DateTime? createdAt,
    List<String>? utensils,
  }) {
    return Recipe(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      preparationTime: preparationTime ?? this.preparationTime,
      cookingTime: cookingTime ?? this.cookingTime,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
      utensils: utensils ?? this.utensils,
    );
  }
}
