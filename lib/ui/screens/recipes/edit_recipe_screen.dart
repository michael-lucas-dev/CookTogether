import 'package:cooktogether/providers/recipe_service_provider.dart';
import 'package:cooktogether/ui/templates/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cooktogether/models/recipe.dart';
import 'package:cooktogether/services/recipe_service.dart';
import 'package:cooktogether/core/logger.dart';
import 'package:go_router/go_router.dart';

class EditRecipeScreen extends ConsumerStatefulWidget {
  final String recipeId;

  const EditRecipeScreen({super.key, required this.recipeId});

  @override
  ConsumerState<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends ConsumerState<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  late TextEditingController _ingredientsController;
  late TextEditingController _stepsController;
  late TextEditingController _preparationTimeController;
  late TextEditingController _cookingTimeController;

  bool _isLoading = true;
  String? _error;
  Recipe? _recipe;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _imageUrlController = TextEditingController();
    _ingredientsController = TextEditingController();
    _stepsController = TextEditingController();
    _preparationTimeController = TextEditingController();
    _cookingTimeController = TextEditingController();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    try {
      final recipeService = ref.read(recipeServiceProvider);
      final recipe = await recipeService.getRecipe(widget.recipeId);
      if (mounted && recipe != null) {
        setState(() {
          _recipe = recipe;
          _updateControllers(recipe);
          _isLoading = false;
        });
      }
      if (recipe == null) {
        if (mounted) {
          setState(() {
            _error = 'Recette non trouvée';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Erreur lors du chargement de la recette';
          _isLoading = false;
        });
      }
    }
  }

  void _updateControllers(Recipe recipe) {
    _titleController.text = recipe.title;
    _descriptionController.text = recipe.description;
    _imageUrlController.text = recipe.imageUrl;
    _ingredientsController.text = recipe.ingredients.join(', ');
    _stepsController.text = recipe.steps.join('\n');
    _preparationTimeController.text = recipe.preparationTime.toString();
    _cookingTimeController.text = recipe.cookingTime.toString();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    _preparationTimeController.dispose();
    _cookingTimeController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate() && _recipe != null) {
      try {
        final recipeService = ref.read(recipeServiceProvider);

        final updatedRecipe = Recipe(
          id: _recipe!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          imageUrl: _imageUrlController.text,
          ingredients: _ingredientsController.text.split(',').map((e) => e.trim()).toList(),
          steps: _stepsController.text.split('\n').map((e) => e.trim()).toList(),
          preparationTime: int.parse(_preparationTimeController.text),
          cookingTime: int.parse(_cookingTimeController.text),
          authorId: _recipe!.authorId,
          createdAt: _recipe!.createdAt,
        );

        await recipeService.updateRecipe(updatedRecipe);

        AppLogger.info('Recette mise à jour avec succès');

        if (context.mounted) {
          context.pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Recette mise à jour avec succès')));
        }
      } catch (e, stackTrace) {
        AppLogger.error('Erreur lors de la mise à jour de la recette', e, stackTrace);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de la mise à jour de la recette')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const BasePage(title: "Edit", body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return BasePage(title: "Edit", body: Center(child: Text(_error!)));
    }

    if (_recipe == null) {
      return const BasePage(title: "Edit", body: Center(child: Text('Recette non trouvée')));
    }

    return BasePage(
      title: "Edit",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL de l\'image',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une URL d\'image';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Ingrédients (séparés par des virgules)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer les ingrédients';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(
                  labelText: 'Étapes de préparation (une par ligne)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer les étapes de préparation';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _preparationTimeController,
                decoration: const InputDecoration(
                  labelText: 'Temps de préparation (minutes)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le temps de préparation';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cookingTimeController,
                decoration: const InputDecoration(
                  labelText: 'Temps de cuisson (minutes)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le temps de cuisson';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: const Text('Mettre à jour la recette'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
