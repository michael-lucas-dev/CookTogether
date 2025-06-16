import 'package:app/models/recipe.dart';
import 'package:app/providers/recipe_service_provider.dart';
import 'package:app/router/app_router.dart';
import 'package:app/ui/templates/main_screen_template.dart';
import 'package:app/ui/widgets/recipe_card.dart';
import 'package:app/ui/widgets/recipe_search_bar.dart';
import 'package:app/ui/widgets/recipe_filter_chips.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeListScreen extends ConsumerWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeService = ref.watch(recipeServiceProvider);
    final searchController = TextEditingController();
    final filters = ['Type et plat', 'Temps', 'Ingrédient'];
    int selectedFilter = 0;

    return MainScreenTemplate(
      title: 'Accueil',
      actions: [IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {})],
      body: StreamBuilder<List<Recipe>>(
        stream: recipeService.getAllRecipesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement: ${snapshot.error}'));
          }

          final recipes = snapshot.data ?? [];
          if (recipes.isEmpty) {
            return const Center(child: Text('Aucune recette disponible'));
          }

          // Pour la démo, on prend les 2 premières comme "en vedette"
          final featuredRecipes = recipes.take(2).toList();
          final otherRecipes = recipes.skip(2).toList();

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RecipeSearchBar(controller: searchController),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: RecipeFilterChips(
                  filters: filters,
                  selectedIndex: selectedFilter,
                  onSelected: (i) {}, // TODO: filter logic
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Text(
                  'Recettes',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 170,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredRecipes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final recipe = featuredRecipes[index];
                    return SizedBox(
                      width: 220,
                      child: RecipeCard(
                        recipe: recipe,
                        onTap: () => context.push("${Locations.recipeDetail}/${recipe.id}"),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  'Toutes les recettes',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              ...otherRecipes.map(
                (recipe) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: RecipeCard(
                    recipe: recipe,
                    onTap: () => context.push("${Locations.recipeDetail}/${recipe.id}"),
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'addRecipe',
            onPressed: () {
              context.push(Locations.addRecipe);
            },
            backgroundColor: Colors.orange,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
