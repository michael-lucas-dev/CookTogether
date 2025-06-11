import 'package:cooktogether/models/recipe.dart';
import 'package:cooktogether/router/app_router.dart';
import 'package:cooktogether/services/recipe_service.dart';
import 'package:cooktogether/ui/templates/main_screen_template.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeService = Provider.of<RecipeService>(context);

    return MainScreenTemplate(
      title: 'Recettes',
      body: StreamBuilder<List<Recipe>>(
        stream: recipeService.getAllRecipesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erreur de chargement: ${snapshot.error}'),
            );
          }

          final recipes = snapshot.data ?? [];

          if (recipes.isEmpty) {
            return const Center(
              child: Text('Aucune recette disponible'),
            );
          }

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return ListTile(
                leading: recipe.imageUrl.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(recipe.imageUrl),
                        onBackgroundImageError: (_, __) => 
                          const Icon(Icons.restaurant),
                      )
                    : const CircleAvatar(child: Icon(Icons.restaurant)),
                title: Text(recipe.title),
                subtitle: Text(recipe.description),
                onTap: () => context.push(Locations.recipeDetail(recipe.id)),
                trailing: const Icon(Icons.chevron_right),
              );
            },
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
          context.push(Locations.addRecipe);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
