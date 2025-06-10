import 'package:flutter/material.dart';
import 'package:cooktogether/router/router_extensions.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste factice de recettes pour l'exemple
    final recipes = List.generate(10, (index) => 'Recette ${index + 1}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Recettes'),
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () => context.goToLogin())],
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipeId = 'recipe_$index';
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.restaurant)),
            title: Text(recipes[index]),
            subtitle: const Text('Cliquez pour voir les détails'),
            onTap: () => context.goToRecipeDetail(recipeId),
            trailing: const Icon(Icons.chevron_right),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implémenter l'ajout d'une recette
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Ajouter une recette')));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
