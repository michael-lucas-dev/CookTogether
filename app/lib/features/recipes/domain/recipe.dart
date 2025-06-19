import 'package:cloud_firestore/cloud_firestore.dart';

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
  final bool isPublic;
  final DateTime createdAt;
  final List<String>? utensils;
  final List<String> groupsShared;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.preparationTime,
    required this.cookingTime,
    required this.authorId,
    required this.isPublic,
    required this.createdAt,
    required this.utensils,
    required this.groupsShared,
  });

  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recipe(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      ingredients: List<String>.from(data['ingredients'] ?? []),
      steps: List<String>.from(data['steps'] ?? []),
      preparationTime: data['preparationTime'],
      cookingTime: data['cookingTime'],
      authorId: data['authorId'],
      isPublic: data['isPublic'],
      createdAt: data['createdAt'],
      utensils: List<String>.from(data['utensils'] ?? []),
      groupsShared: List<String>.from(data['groupsShared'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'steps': steps,
      'preparationTime': preparationTime,
      'cookingTime': cookingTime,
      'authorId': authorId,
      'isPublic': isPublic,
      'createdAt': createdAt,
      'utensils': utensils,
      'groupsShared': groupsShared,
    };
  }
}
