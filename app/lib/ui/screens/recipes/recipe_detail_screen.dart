import 'package:app/providers/auth_providers.dart';
import 'package:app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/recipe.dart';
import 'package:app/core/logger.dart';
import 'package:app/providers/recipe_service_provider.dart';
import 'package:go_router/go_router.dart';

class RecipeDetailScreen extends ConsumerWidget {
  static const String routeName = '/recipe-detail';
  final String recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint(recipeId);
    final recipeService = ref.watch(recipeServiceProvider);

    return FutureBuilder<Recipe?>(
      future: recipeService.getRecipe(recipeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          AppLogger.error('Erreur lors du chargement de la recette', snapshot.error);
          return const Scaffold(
            body: Center(child: Text('Erreur lors du chargement de la recette')),
          );
        }

        final recipe = snapshot.data;
        if (recipe == null) {
          return const Scaffold(body: Center(child: Text('Recette non trouvée')));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(recipe.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  // TODO: Implement favorite functionality
                },
              ),
              if (recipe.authorId == ref.watch(authStateProvider).value!.uid)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (ctx) => AlertDialog(
                            title: const Text('Supprimer la recette'),
                            content: const Text('Voulez-vous vraiment supprimer cette recette ?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Annuler'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text('Supprimer'),
                              ),
                            ],
                          ),
                    );
                    if (confirm == true) {
                      await ref.read(recipeServiceProvider).deleteRecipe(recipe.id);
                      if (context.mounted) {
                        context.pop();
                      }
                    }
                  },
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image de la recette
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    recipe.imageUrl ?? 'https://via.placeholder.com/400x200?text=No+Image',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16.0),

                // Informations de base
                Row(
                  children: [
                    _buildInfoChip(
                      icon: Icons.timer_outlined,
                      text: '${recipe.preparationTime} min',
                    ),
                    const SizedBox(width: 8.0),
                    _buildInfoChip(
                      icon: Icons.local_fire_department_outlined,
                      text: '${recipe.cookingTime} min',
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Description
                Text('Description', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8.0),
                Text(recipe.description ?? ''),
                const SizedBox(height: 24.0),

                // Ingrédients
                Text('Ingrédients', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8.0),
                ...recipe.ingredients.map(
                  (ingredient) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text('• $ingredient'),
                  ),
                ),
                const SizedBox(height: 24.0),

                // Étapes de préparation
                Text('Étapes de préparation', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8.0),
                ...recipe.steps.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(child: Text(entry.value)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton:
              recipe.authorId == ref.watch(authStateProvider).value!.uid
                  ? FloatingActionButton(
                    onPressed: () {
                      context.push(Locations.editRecipe, extra: recipe);
                    },
                    child: const Icon(Icons.edit),
                  )
                  : null,
        );
      },
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16), const SizedBox(width: 4.0), Text(text)],
      ),
      backgroundColor: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    );
  }
}
