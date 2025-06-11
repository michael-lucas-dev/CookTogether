import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cooktogether/models/recipe.dart';
import 'package:cooktogether/services/recipe_service.dart';
import 'package:cooktogether/core/logger.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeService _recipeService;
  List<Recipe> _recipes = [];
  bool _isLoading = false;

  RecipeProvider(this._recipeService);

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;

  // Charger toutes les recettes de l'utilisateur
  Future<void> loadUserRecipes(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final stream = _recipeService.getUserRecipesStream(userId);

      stream.listen(
        (recipes) {
          _recipes = recipes;
          _isLoading = false;
          notifyListeners();
        },
        onError: (error, stackTrace) {
          AppLogger.error('Erreur lors du chargement des recettes', error, stackTrace);
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors du chargement des recettes', e, stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ajouter une nouvelle recette
  Future<void> addRecipe(Recipe recipe) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _recipeService.addRecipe(recipe);

      // La recette sera automatiquement ajoutée grâce au stream
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de l\'ajout de la recette', e, stackTrace);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mettre à jour une recette existante
  Future<void> updateRecipe(Recipe recipe) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _recipeService.updateRecipe(recipe);

      // La recette sera automatiquement mise à jour grâce au stream
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la mise à jour de la recette', e, stackTrace);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Supprimer une recette
  Future<void> deleteRecipe(String recipeId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _recipeService.deleteRecipe(recipeId);

      // La recette sera automatiquement supprimée grâce au stream
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la suppression de la recette', e, stackTrace);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtenir une recette par ID
  Future<Recipe?> getRecipe(String recipeId) async {
    try {
      _isLoading = true;
      notifyListeners();

      return await _recipeService.getRecipe(recipeId);
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la récupération de la recette', e, stackTrace);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
