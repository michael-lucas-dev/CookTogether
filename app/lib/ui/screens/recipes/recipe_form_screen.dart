import 'dart:io';
import 'package:app/ui/templates/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:app/models/recipe.dart';
import 'package:app/providers/auth_providers.dart';
import 'package:app/providers/recipe_service_provider.dart';

/// Unifie l'ajout et l'édition de recette, et supporte la création par IA.
class RecipeFormScreen extends ConsumerStatefulWidget {
  final Recipe? recipe;

  const RecipeFormScreen({super.key, this.recipe});

  @override
  ConsumerState<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends ConsumerState<RecipeFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _ingredientsController;
  late TextEditingController _stepsController;
  late TextEditingController _preparationTimeController;
  late TextEditingController _cookingTimeController;
  late TabController _tabController;

  XFile? _pickedImage;
  XFile? _pickedImageForAI;
  bool _isRecognizing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    setController(widget.recipe);
  }

  setController(Recipe? recipe) {
    _titleController = TextEditingController(text: recipe?.title ?? '');
    _descriptionController = TextEditingController(text: recipe?.description ?? '');
    _ingredientsController = TextEditingController(text: recipe?.ingredients.join(', ') ?? '');
    _stepsController = TextEditingController(text: recipe?.steps.join('\n') ?? '');
    _preparationTimeController = TextEditingController(
      text: recipe?.preparationTime.toString() ?? '',
    );
    _cookingTimeController = TextEditingController(text: recipe?.cookingTime.toString() ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    _preparationTimeController.dispose();
    _cookingTimeController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context, {bool forAI = false}) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder:
          (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Depuis la galerie'),
                  onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Prendre une photo'),
                  onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
                ),
              ],
            ),
          ),
    );
    if (source != null) {
      final XFile? image = await picker.pickImage(source: source, maxWidth: 1200, maxHeight: 1200);
      if (image != null) {
        setState(() {
          if (forAI) {
            _pickedImageForAI = image;
          } else {
            _pickedImage = image;
          }
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authStateProvider).value;
    if (user == null) return;
    try {
      final recipe = Recipe(
        id: widget.recipe?.id ?? '',
        title: _titleController.text,
        description: _descriptionController.text,
        ingredients: _ingredientsController.text.split(',').map((e) => e.trim()).toList(),
        steps: _stepsController.text.split('\n').map((e) => e.trim()).toList(),
        preparationTime: int.tryParse(_preparationTimeController.text) ?? 0,
        cookingTime: int.tryParse(_cookingTimeController.text) ?? 0,
        authorId: widget.recipe?.authorId ?? user.uid,
        createdAt: widget.recipe?.createdAt ?? DateTime.now(),
      );
      final recipeService = ref.read(recipeServiceProvider);

      final imageFile = _pickedImage != null ? File(_pickedImage!.path) : null;
      if (widget.recipe == null) {
        await recipeService.addRecipe(recipe: recipe, imageFile: imageFile);
      } else {
        await recipeService.updateRecipe(recipe, imageFile);
      }
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.recipe == null ? 'Recette ajoutée !' : 'Recette modifiée !'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }

  Future<void> _analyzeImageWithAI(BuildContext context) async {
    if (_pickedImageForAI == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Aucune image sélectionnée')));
      }
      return;
    }
    setState(() => _isRecognizing = true);
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) return;
      final inputImage = InputImage.fromFilePath(_pickedImageForAI!.path);
      final recipe = await ref
          .read(recipeServiceProvider)
          .recognizeRecipeFromImage(inputImage, authorId: user.uid);
      setController(recipe);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur IA : $e')));
      }
    } finally {
      setState(() => _isRecognizing = false);
      _tabController.animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: BasePage(
        title: widget.recipe == null ? 'Ajouter une recette' : 'Modifier la recette',
        appBarBottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Manuel', icon: Icon(Icons.edit)),
            Tab(text: "À partir d'une image", icon: Icon(Icons.camera_alt)),
          ],
        ),
        actions: [
          if (widget.recipe != null)
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
                  await ref.read(recipeServiceProvider).deleteRecipe(widget.recipe!.id);
                  if (context.mounted) {
                    context.pop();
                  }
                }
              },
            ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [_manualRecipeForm(context), _imageRecipeCapture(context)],
        ),
      ),
    );
  }

  Widget _manualRecipeForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_pickedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_pickedImage!.path),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: Text(_pickedImage == null ? 'Choisir une image' : 'Changer l\'image'),
              onPressed: () => _pickImage(context),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre', border: OutlineInputBorder()),
              validator:
                  (value) => value == null || value.isEmpty ? 'Veuillez entrer un titre' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ingredientsController,
              decoration: const InputDecoration(
                labelText: 'Ingrédients (séparés par des virgules)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator:
                  (value) =>
                      value == null || value.isEmpty ? 'Veuillez entrer les ingrédients' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _stepsController,
              decoration: const InputDecoration(
                labelText: 'Étapes de préparation (une par ligne)',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Veuillez entrer les étapes de préparation'
                          : null,
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
                if (value == null || value.isEmpty)
                  return 'Veuillez entrer le temps de préparation';
                if (int.tryParse(value) == null) return 'Veuillez entrer un nombre valide';
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
                if (value == null || value.isEmpty) return 'Veuillez entrer le temps de cuisson';
                if (int.tryParse(value) == null) return 'Veuillez entrer un nombre valide';
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.recipe == null ? 'Créer la recette' : 'Mettre à jour la recette'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageRecipeCapture(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_pickedImageForAI != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_pickedImageForAI!.path),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            )
          else
            Icon(Icons.camera_alt, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            "Prenez une photo d'une recette pour l'ajouter automatiquement",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: Text(_pickedImageForAI == null ? 'Choisir une image' : 'Changer l\'image'),
            onPressed: () => _pickImage(context, forAI: true),
          ),
          if (_pickedImageForAI != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.text_snippet),
              label:
                  _isRecognizing
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('Analyser l\'image'),
              onPressed: _isRecognizing ? null : () => _analyzeImageWithAI(context),
            ),
          ],
        ],
      ),
    );
  }
}
