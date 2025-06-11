import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cooktogether/services/recipe_service.dart';
import 'package:cooktogether/providers/firebase_providers.dart';

final recipeServiceProvider = Provider<RecipeService>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return RecipeService(firestoreService);
});
