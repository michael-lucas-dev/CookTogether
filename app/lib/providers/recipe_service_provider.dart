import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/recipe_service.dart';
import 'package:app/providers/firebase_providers.dart';

final recipeServiceProvider = Provider<RecipeService>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return RecipeService(firestoreService);
});
