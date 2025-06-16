import 'dart:convert';
import 'dart:io';

import 'package:app/services/firestore_service.dart';
import 'package:app/services/storage_service.dart';
import 'package:app/models/recipe.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../core/logger.dart';

class RecipeService {
  final FirestoreService _firestoreService;
  final StorageService _storageService;

  RecipeService(this._firestoreService, this._storageService);

  /// Ajouter une nouvelle recette avec gestion de l'upload d'image
  Future<Recipe> addRecipe({required Recipe recipe, File? imageFile}) async {
    try {
      AppLogger.info('Ajout d\'une nouvelle recette');
      final docRef = await _firestoreService.addDocument('recipes', recipe.toMap());
      var updatedRecipe = recipe.copyWith(id: docRef.id);
      if (imageFile != null) {
        final imageUrl = await uploadImage(imageFile: imageFile, recipeId: docRef.id);
        updatedRecipe = updatedRecipe.copyWith(imageUrl: imageUrl);
      }
      await _firestoreService.updateDocument('recipes/${docRef.id}', updatedRecipe.toMap());
      AppLogger.info('Recette ajoutée avec succès');
      return updatedRecipe;
    } catch (e, stackTrace) {
      AppLogger.error("Erreur lors de l'ajout de la recette avec image", e, stackTrace);
      rethrow;
    }
  }

  /// Upload de l'image
  Future<String> uploadImage({required File imageFile, required String recipeId}) async {
    try {
      AppLogger.info('Upload de l\'image');
      final fileName = 'recipes/${recipeId}_${DateTime.now().millisecondsSinceEpoch}}';
      final imageUrl = await _storageService.uploadFile(file: imageFile, path: fileName);
      AppLogger.info('Image uploadée avec succès');
      return imageUrl;
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de l\'upload de l\'image', e, stackTrace);
      rethrow;
    }
  }

  // Mettre à jour une recette existante
  Future<void> updateRecipe(Recipe recipe, File? imageFile) async {
    try {
      AppLogger.info('Mise à jour de la recette ${recipe.id}');
      if (imageFile != null) {
        final imageUrl = await uploadImage(imageFile: imageFile, recipeId: recipe.id);
        recipe = recipe.copyWith(imageUrl: imageUrl);
        debugPrint('Image uploadée avec succès, $imageUrl -> ${recipe.imageUrl}');
      }
      await _firestoreService.updateDocument('recipes/${recipe.id}', recipe.toMap());
      AppLogger.info('Recette mise à jour avec succès');
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la mise à jour de la recette', e, stackTrace);
      rethrow;
    }
  }

  // Supprimer une recette
  Future<void> deleteRecipe(String recipeId) async {
    try {
      AppLogger.info('Suppression de la recette $recipeId');
      await _firestoreService.deleteDocument('recipes/$recipeId');
      AppLogger.info('Recette supprimée avec succès');
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la suppression de la recette', e, stackTrace);
      rethrow;
    }
  }

  // Obtenir une recette par ID
  Future<Recipe?> getRecipe(String recipeId) async {
    try {
      AppLogger.info('Récupération de la recette $recipeId');
      final doc = await _firestoreService.getDocument('recipes/$recipeId');

      if (doc.exists) {
        return Recipe.fromMap(doc.data()! as Map<String, dynamic>);
      }
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la récupération de la recette', e, stackTrace);
      rethrow;
    }
  }

  // Obtenir toutes les recettes d'un utilisateur
  Stream<List<Recipe>> getUserRecipesStream(String userId) {
    return _firestoreService
        .streamCollection(
          'recipes',
          queryBuilder: (query) => query.where('authorId', isEqualTo: userId),
        )
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Recipe.fromMap(doc.data()! as Map<String, dynamic>))
                  .toList(),
        );
  }

  // Obtenir toutes les recettes
  Stream<List<Recipe>> getAllRecipesStream() {
    return _firestoreService
        .streamCollection('recipes')
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Recipe.fromMap(doc.data()! as Map<String, dynamic>))
                  .toList(),
        );
  }

  Future<String?> recognizeTextFromImageWithAI(InputImage image) async {
    try {
      final file = File(image.filePath!);
      final bytes = file.readAsBytesSync();
      final model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.0-flash');
      final prompt = TextPart("""
    Analyse l'image et renvoie un JSON structuré avec les champs suivants :
    - titre
    - description (texte ou vide)
    - ingredients (liste)
    - etapes (liste)
    - temps_preparation (en minutes ou null)
    - temps_cuisson (en minutes ou null)
    - ustensiles (liste ou vide)
  """);
      final imagePart = InlineDataPart('image/jpeg', bytes);
      final response = await model.generateContent([
        Content.multi([prompt, imagePart]),
      ]);
      return response.text;
    } catch (e) {
      AppLogger.error('Erreur lors de la reconnaissance du texte', e);
      throw 'Erreur lors de la reconnaissance du texte';
    }
  }

  Future<Recipe> recognizeRecipeFromImage(InputImage image, {required String authorId}) async {
    try {
      if (image.filePath == null || image.bytes == null) {
        throw 'Image non valide';
      }

      final file = File(image.filePath!);
      final bytes = file.readAsBytesSync();

      final model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.0-flash');
      final prompt = TextPart("""
    Analyse l'image et renvoie un JSON structuré avec les champs suivants :
    - titre
    - description (texte ou vide)
    - ingredients (liste)
    - etapes (liste)
    - temps_preparation (en minutes ou null)
    - temps_cuisson (en minutes ou null)
    - ustensiles (liste ou vide)
    """);
      final imagePart = InlineDataPart('image/jpeg', bytes);
      final response = await model.generateContent([
        Content.multi([prompt, imagePart]),
      ]);
      final Map<String, dynamic> data = jsonDecode(response.text!);

      return Recipe(
        id: '',
        title: data['titre'] ?? '',
        description: data['description'],
        ingredients:
            (data['ingredients'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        steps: (data['etapes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        preparationTime:
            data['temps_preparation'] is int
                ? data['temps_preparation']
                : int.tryParse(data['temps_preparation']?.toString() ?? '') ?? 0,
        cookingTime:
            data['temps_cuisson'] is int
                ? data['temps_cuisson']
                : int.tryParse(data['temps_cuisson']?.toString() ?? '') ?? 0,
        authorId: authorId,
        createdAt: DateTime.now(),
        utensils: (data['ustensiles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      );
    } catch (e) {
      AppLogger.error('Erreur lors de la reconnaissance du texte', e);
      rethrow;
    }
  }
}
