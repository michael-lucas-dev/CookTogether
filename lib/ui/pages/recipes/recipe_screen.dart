import 'package:cooktogether/models/recipe.dart';
import 'package:cooktogether/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cooktogether/core/logger.dart';
import 'package:go_router/go_router.dart';

class RecipeScreen extends ConsumerStatefulWidget {
  const RecipeScreen({super.key});

  @override
  ConsumerState<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends ConsumerState<RecipeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    AppLogger.info('Initialisation de l\'écran d\'accueil');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showAddRecipeDialog() async {
    final user = ref.read(authStateProvider).value;

    if (user == null) {
      AppLogger.info('Utilisateur non connecté lors de l\'ajout de recette');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez vous connecter pour ajouter une recette')),
      );
      return;
    }

    try {
      AppLogger.info('Affichage du dialogue d\'ajout de recette');
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ajouter une recette'),
          content: const Text('Voulez-vous ajouter une nouvelle recette ?'),
          actions: [
            TextButton(onPressed: () => context.pop(), child: const Text('Annuler')),
            TextButton(onPressed: () => context.pop(), child: const Text('Ajouter')),
          ],
        ),
      );

      if (result ?? false) {
        AppLogger.info('Création d\'une nouvelle recette');
        // TODO: Implémenter la création de recette
      }
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de l\'affichage du dialogue d\'ajout de recette', e, stackTrace);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CookTogether'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _showAddRecipeDialog),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Recipe>>(
        future: Future.delayed(const Duration(seconds: 2)).then((value) => []),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            AppLogger.info('Chargement des recettes');
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            AppLogger.error('Erreur lors du chargement des recettes', snapshot.error);
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          final recipes = snapshot.data ?? [];
          AppLogger.info('${recipes.length} recettes chargées avec succès');

          if (recipes.isEmpty) {
            return const Center(child: Text('Aucune recette disponible'));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      recipe.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        AppLogger.error('Erreur lors du chargement de l\'image', error, stackTrace);
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                  title: Text(recipe.title),
                  subtitle: Text(
                    '${recipe.cookingTime} min • ${recipe.ingredients.length} ingrédients',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      AppLogger.info('Ajout aux favoris pour la recette: ${recipe.title}');
                      // TODO: Implement favorite
                    },
                  ),
                  onTap: () {
                    AppLogger.info('Affichage des détails de la recette: ${recipe.title}');
                    // TODO: Navigate to recipe details
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
