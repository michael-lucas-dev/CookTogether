import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/recipes/data/recipe_service.dart';
import 'package:app/sort/firebase_providers.dart';

final recipeServiceProvider = Provider<RecipeService>((ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  final storageService = ref.read(storageServiceProvider);
  return RecipeService(firestoreService, storageService);
});
