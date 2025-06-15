import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:app/models/recipe.dart';
import 'package:app/core/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/auth_providers.dart';
import 'package:app/providers/recipe_service_provider.dart';

class AddRecipeScreen extends ConsumerStatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  ConsumerState<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends ConsumerState<AddRecipeScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();
  final _preparationTimeController = TextEditingController();
  final _cookingTimeController = TextEditingController();

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
        final recipe = Recipe(
          title: _titleController.text,
          description: _descriptionController.text,
          imageUrl: _imageUrlController.text,
          ingredients: _ingredientsController.text.split(',').map((e) => e.trim()).toList(),
          steps: _stepsController.text.split('\n').map((e) => e.trim()).toList(),
          preparationTime: int.parse(_preparationTimeController.text),
          cookingTime: int.parse(_cookingTimeController.text),
          authorId: ref.watch(authStateProvider).value!.uid,
          createdAt: DateTime.now(),
        );

        await ref.read(recipeServiceProvider).addRecipe(recipe);

        AppLogger.info('Recette ajoutée avec succès');

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Recette ajoutée avec succès')));
        }
      } catch (e, stackTrace) {
        AppLogger.error('Erreur lors de l\'ajout de la recette', e, stackTrace);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Erreur lors de l\'ajout de la recette')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ajouter une recette'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Manuel', icon: Icon(Icons.edit)),
              Tab(text: "À partir d'une image", icon: Icon(Icons.camera_alt)),
            ],
          ),
        ),
        body: TabBarView(children: [_manualRecipeForm(), _imageRecipeCapture()]),
      ),
    );
  }

  Widget _manualRecipeForm() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
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
            ElevatedButton(onPressed: _submitForm, child: const Text('Ajouter la recette')),
          ],
        ),
      ),
    );
  }

  XFile? _pickedImage;
  String? _recognizedText;
  int _isRecognizing = 0;

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
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
      debugPrint('Source: $source');
      final XFile? image = await picker.pickImage(source: source, maxWidth: 1200, maxHeight: 1200);
      if (image != null) {
        setState(() {
          _pickedImage = image;
        });
      }
    }
  }

  Future<void> _aiText(BuildContext context) async {
    if (_pickedImage == null) return;
    setState(() {
      _isRecognizing = 2;
      _recognizedText = null;
    });
    final inputImage = InputImage.fromFilePath(_pickedImage!.path);
    try {
      final String? result = await ref
          .read(recipeServiceProvider)
          .recognizeTextFromImageWithAI(inputImage);
      setState(() {
        _recognizedText = result;
      });
    } catch (e) {
      setState(() {
        _recognizedText = 'Erreur lors de la reconnaissance du texte';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erreur lors de la reconnaissance du texte')));
    } finally {
      setState(() {
        _isRecognizing = 0;
      });
    }
  }

  Widget _imageRecipeCapture() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            label: Text(_pickedImage == null ? 'Choisir une image' : 'Changer l\'image'),
            onPressed: () => _pickImage(context),
          ),
          if (_pickedImage != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.text_snippet),
              label:
                  _isRecognizing != 0
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('Analyser l\'image'),
              onPressed: _isRecognizing != 0 ? null : () => _aiText(context),
            ),
          ],
          if (_recognizedText != null) ...[
            const SizedBox(height: 24),
            const Text('Texte reconnu :', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_recognizedText!),
            ),
          ],
        ],
      ),
    );
  }
}
