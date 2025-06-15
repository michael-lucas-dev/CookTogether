import 'package:app/services/firestore_service.dart';
import 'package:app/models/recipe.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../core/logger.dart';

class RecipeService {
  final FirestoreService _firestoreService;

  RecipeService(this._firestoreService);

  // Ajouter une nouvelle recette
  Future<Recipe> addRecipe(Recipe recipe) async {
    try {
      AppLogger.info('Ajout d\'une nouvelle recette');
      final docRef = await _firestoreService.addDocument('recipes', recipe.toMap());

      // Mettre à jour l'ID de la recette avec l'ID Firestore
      final updatedRecipe = Recipe(
        id: docRef.id,
        title: recipe.title,
        description: recipe.description,
        imageUrl: recipe.imageUrl,
        ingredients: recipe.ingredients,
        steps: recipe.steps,
        preparationTime: recipe.preparationTime,
        cookingTime: recipe.cookingTime,
        authorId: recipe.authorId,
        createdAt: recipe.createdAt,
      );

      // Mettre à jour le document avec l'ID
      await _firestoreService.updateDocument('recipes/${docRef.id}', updatedRecipe.toMap());

      AppLogger.info('Recette ajoutée avec succès');
      return updatedRecipe;
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de l\'ajout de la recette', e, stackTrace);
      rethrow;
    }
  }

  // Mettre à jour une recette existante
  Future<void> updateRecipe(Recipe recipe) async {
    try {
      AppLogger.info('Mise à jour de la recette ${recipe.id}');
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

  Future<String> recognizeTextFromImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    String result;
    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(image);
      result = cleanOcrRecipe(recognizedText.text);
    } catch (e) {
      AppLogger.error('Erreur lors de la reconnaissance du texte', e);
      throw 'Erreur lors de la reconnaissance du texte';
    } finally {
      textRecognizer.close();
    }
    return result;
  }

  Future<String?> recognizeTextFromImageWithAI(InputImage image) async {
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
    final imagePart = InlineDataPart('image/jpeg', image.bytes!);
    final response = await model.generateContent([
      Content.multi([prompt, imagePart]),
    ]);
    return response.text;
  }

  Future<String?> recognizeTextFromImageWithAIBoosted(InputImage image) async {
    final ocrText = await recognizeTextFromImage(image);
    final model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.0-flash');
    final prompt = TextPart("""
    Voici un texte OCR d'une recette de cuisine :$ocrText

    Analyse le texte ainsi que l'image et renvoie un JSON structuré avec les champs suivants :
    - titre
    - description (texte ou vide)
    - ingredients (liste)
    - etapes (liste)
    - temps_preparation (en minutes ou null)
    - temps_cuisson (en minutes ou null)
    - ustensiles (liste ou vide)
  """);
    final imagePart = InlineDataPart('image/jpeg', image.bytes!);
    final response = await model.generateContent([
      Content.multi([prompt, imagePart]),
    ]);
    return response.text;
  }

  String cleanOcrRecipe(String rawText) {
    String text = rawText;

    // Erreurs courantes OCR à corriger
    final Map<String, String> commonCorrections = {
      r'\bOeufs?\b': 'œufs',
      r'\b1\b(?=\s+cuill[eé]re)': '1', // l mal reconnu en 1
      r'\blait\b': 'lait', // parfois "Iait"
      r'\blarlne\b': 'farine',
      r'\bfaclles\b': 'faciles',
      r'\bmetter?\b': 'mettre',
      r'\bsaladler\b': 'saladier',
      r'(?<=\d)\s*ml': 'ml',
      r'(?<=\d)\s*g': 'g',
      r'\s{2,}': ' ', // Supprimer les espaces multiples
    };

    commonCorrections.forEach((pattern, replacement) {
      text = text.replaceAllMapped(RegExp(pattern, caseSensitive: false), (match) => replacement);
    });

    // Normalisation des titres de section
    text = text.replaceAllMapped(
      RegExp(r'(?i)(ingr[eé]dients)[\s:\n]*'),
      (m) => '\n\nIngrédients:\n',
    );
    text = text.replaceAllMapped(
      RegExp(r'(?i)(pr[eé]paration|e?tapes?)[\s:\n]*'),
      (m) => '\n\nPréparation:\n',
    );

    // Forcer les listes d'ingrédients en puces
    text = text.replaceAllMapped(
      RegExp(r'(?<=Ingrédients:\n)([^•\n-].+)', multiLine: true),
      (m) => '- ${m.group(1)}',
    );

    // Nettoyage de début/fin
    text = text.trim();

    return text;
  }
}
