import 'package:flutter/material.dart';
import 'package:cooktogether/models/recipe.dart';
import 'package:cooktogether/services/recipe_service.dart';
import 'package:cooktogether/core/logger.dart';

class EditRecipeForm extends StatefulWidget {
  final Recipe recipe;
  final RecipeService recipeService;

  const EditRecipeForm({
    super.key,
    required this.recipe,
    required this.recipeService,
  });

  @override
  State<EditRecipeForm> createState() => _EditRecipeFormState();
}

class _EditRecipeFormState extends State<EditRecipeForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  late TextEditingController _ingredientsController;
  late TextEditingController _stepsController;
  late TextEditingController _preparationTimeController;
  late TextEditingController _cookingTimeController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipe.title);
    _descriptionController = TextEditingController(text: widget.recipe.description);
    _imageUrlController = TextEditingController(text: widget.recipe.imageUrl);
    _ingredientsController = TextEditingController(text: widget.recipe.ingredients.join(', '));
    _stepsController = TextEditingController(text: widget.recipe.steps.join('\n'));
    _preparationTimeController = TextEditingController(text: widget.recipe.preparationTime.toString());
    _cookingTimeController = TextEditingController(text: widget.recipe.cookingTime.toString());
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedRecipe = Recipe(
          id: widget.recipe.id,
          title: _titleController.text,
          description: _descriptionController.text,
          imageUrl: _imageUrlController.text,
          ingredients: _ingredientsController.text.split(',').map((e) => e.trim()).toList(),
          steps: _stepsController.text.split('\n').map((e) => e.trim()).toList(),
          preparationTime: int.parse(_preparationTimeController.text),
          cookingTime: int.parse(_cookingTimeController.text),
          authorId: widget.recipe.authorId,
          createdAt: widget.recipe.createdAt,
        );

        await widget.recipeService.updateRecipe(updatedRecipe);
        
        AppLogger.info('Recette mise à jour avec succès');
        
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recette mise à jour avec succès')),
          );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier la recette'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(),
                ),
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
                onPressed: _submitForm,
                child: const Text('Mettre à jour la recette'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
