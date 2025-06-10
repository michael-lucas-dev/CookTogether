import 'package:cooktogether/ui/templates/main_screen_template.dart';
import 'package:flutter/material.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste factice de recettes pour l'exemple
    final recipes = List.generate(10, (index) => 'Recette ${index + 1}');

    return MainScreenTemplate(
      title: 'Recettes',
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipeId = 'recipe_$index';
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.restaurant)),
            title: Text(recipes[index]),
            subtitle: const Text('Cliquez pour voir les détails'),
            //onTap: () => context.push(Locations.recipeDetail(recipeId)),
            trailing: const Icon(Icons.chevron_right),
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => {
            //TODO: Search
          },
        ),
      ],
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
