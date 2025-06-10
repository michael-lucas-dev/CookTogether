import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/recipe.dart';
import '../../core/logger.dart';

class RecipeRepository {
  final FirebaseFirestore _firestore;

  RecipeRepository(this._firestore);

  Future<List<Recipe>> getRecipes() async {
    try {
      AppLogger.info('Récupération des recettes');
      final snapshot = await _firestore.collection('recipes').get();
      final recipes = snapshot.docs.map((doc) => Recipe.fromMap({...doc.data(), 'id': doc.id})).toList();
      AppLogger.info('${recipes.length} recettes récupérées avec succès');
      return recipes;
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la récupération des recettes', e, stackTrace);
      rethrow;
    }
  }

  Future<Recipe?> getRecipeById(String id) async {
    try {
      AppLogger.info('Récupération de la recette avec ID: $id');
      final doc = await _firestore.collection('recipes').doc(id).get();
      if (!doc.exists) {
        AppLogger.warning('Recette non trouvée pour l\'ID: $id');
        return null;
      }
      AppLogger.info('Recette récupérée avec succès');
      return Recipe.fromMap({...doc.data()!, 'id': doc.id});
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la récupération de la recette', e, stackTrace);
      rethrow;
    }
  }

  Future<void> createRecipe(Recipe recipe) async {
    try {
      AppLogger.info('Ajout de la recette: ${recipe.title}');
      final docRef = await _firestore.collection('recipes').add(recipe.toMap());
      // Update the recipe with the generated ID
      await docRef.update({'id': docRef.id});
      AppLogger.info('Recette ajoutée avec succès');
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de l\'ajout de la recette', e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateRecipe(Recipe recipe) async {
    try {
      AppLogger.info('Mise à jour de la recette: ${recipe.title}');
      await _firestore.collection('recipes').doc(recipe.id).update(recipe.toMap());
      AppLogger.info('Recette mise à jour avec succès');
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la mise à jour de la recette', e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      AppLogger.info('Suppression de la recette avec ID: $id');
      await _firestore.collection('recipes').doc(id).delete();
      AppLogger.info('Recette supprimée avec succès');
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la suppression de la recette', e, stackTrace);
      rethrow;
    }
  }
}
