import 'package:flutter/material.dart';
import 'package:cooktogether/core/routes/router_extensions.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de la recette'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implémenter l'édition
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Éditer la recette')));
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
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.fastfood, size: 80, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            // Titre
            Text(
              'Recette détaillée #${recipeId.split('_').last}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            // Ingrédients
            const Text('Ingrédients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('• Farine\n• Œufs\n• Lait\n• Sucre'),
            const SizedBox(height: 24),
            // Étapes
            const Text('Préparation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              '1. Mélanger les ingrédients secs\n2. Ajouter les œufs\n3. Cuire à feu doux',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pop(),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
