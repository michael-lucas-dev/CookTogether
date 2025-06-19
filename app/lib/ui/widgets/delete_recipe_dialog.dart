import 'package:flutter/material.dart';
import 'package:app/features/recipes/domain/recipe.dart';
import 'package:app/features/recipes/data/recipe_service.dart';
import 'package:app/core/logger.dart';

class DeleteRecipeDialog extends StatelessWidget {
  final Recipe recipe;
  final RecipeService recipeService;

  const DeleteRecipeDialog({super.key, required this.recipe, required this.recipeService});

  Future<void> _deleteRecipe(BuildContext context) async {
    try {
      await recipeService.deleteRecipe(recipe.id);
      AppLogger.info('Recette supprimée avec succès');

      if (context.mounted) {
        Navigator.pop(context, true); // Retourne true pour indiquer la suppression
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Recette supprimée avec succès')));
      }
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la suppression de la recette', e, stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la suppression de la recette')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Supprimer la recette'),
      content: Text(
        'Êtes-vous sûr de vouloir supprimer la recette "${recipe.title}" ?\nCette action est irréversible.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false), // Retourne false pour annuler
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () => _deleteRecipe(context),
          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
          child: const Text('Supprimer'),
        ),
      ],
    );
  }
}
