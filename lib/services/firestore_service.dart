import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooktogether/models/user_model.dart';
import '../core/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference, DocumentSnapshot, QuerySnapshot, Query;

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  // Méthode générique pour ajouter un document
  Future<DocumentReference> addDocument(String collectionPath, Map<String, dynamic> data) {
    return _firestore.collection(collectionPath).add(data);
  }

  // Méthode générique pour mettre à jour un document
  Future<void> updateDocument(String documentPath, Map<String, dynamic> data) {
    return _firestore.doc(documentPath).update(data);
  }

  // Méthode générique pour supprimer un document
  Future<void> deleteDocument(String documentPath) {
    return _firestore.doc(documentPath).delete();
  }

  // Stream pour suivre les changements en temps réel
  Stream<QuerySnapshot> streamCollection(
    String collectionPath, {
    Query Function(Query)? queryBuilder,
  }) {
    Query<Object?> query = _firestore.collection(collectionPath);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots();
  }

  // Méthode pour obtenir un document unique
  Future<DocumentSnapshot> getDocument(String documentPath) {
    return _firestore.doc(documentPath).get();
  }

  // Méthode spécifique pour créer un utilisateur dans Firestore
  Future<void> createUserInFirestore(UserModel userModel) async {
    try {
      AppLogger.info('Création de l\'utilisateur dans Firestore pour UID: ${userModel.uid}');
      await _firestore.collection('users').doc(userModel.uid).set(userModel.toJson());
      AppLogger.info('Utilisateur créé avec succès dans Firestore');
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la création de l\'utilisateur dans Firestore', e, stackTrace);
      rethrow;
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      AppLogger.info('Récupération de l\'utilisateur avec UID: $uid');
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        AppLogger.info('Utilisateur trouvé dans Firestore');
        return UserModel.fromMap(doc.data()!);
      }
      AppLogger.info('Utilisateur non trouvé dans Firestore');
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la récupération de l\'utilisateur', e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateUser(UserModel userModel) async {
    try {
      AppLogger.info('Mise à jour de l\'utilisateur dans Firestore pour UID: ${userModel.uid}');
      await _firestore.collection('users').doc(userModel.uid).update(userModel.toJson());
      AppLogger.info('Utilisateur mis à jour avec succès dans Firestore');
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la mise à jour de l\'utilisateur', e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      AppLogger.info('Suppression de l\'utilisateur avec UID: $uid');
      await _firestore.collection('users').doc(uid).delete();
      AppLogger.info('Utilisateur supprimé avec succès');
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la suppression de l\'utilisateur', e, stackTrace);
      rethrow;
    }
  }
}
