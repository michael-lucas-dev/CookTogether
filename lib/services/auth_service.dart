import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../core/logger.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Stream<UserModel?> get user => _auth.authStateChanges().map((user) {
    if (user == null) return null;
    return UserModel(uid: user.uid, email: user.email!, displayName: user.displayName);
  });

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Tentative de connexion avec email: $email');
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      AppLogger.info('Connexion réussie');
      return UserModel.fromFirebase(credential.user!);
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la connexion', e, stackTrace);
      rethrow;
    }
  }

  Future<UserModel> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Tentative de création de compte avec email: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppLogger.info('Compte créé avec succès');
      return UserModel.fromFirebase(credential.user!);
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la création de compte', e, stackTrace);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      AppLogger.info('Déconnexion en cours');
      await _auth.signOut();
      AppLogger.info('Déconnexion réussie');
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la déconnexion', e, stackTrace);
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      AppLogger.info('Tentative d\'envoi de réinitialisation de mot de passe pour: $email');
      await _auth.sendPasswordResetEmail(email: email);
      AppLogger.info('Email de réinitialisation envoyé avec succès');
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de l\'envoi de l\'email de réinitialisation', e, stackTrace);
      rethrow;
    }
  }

  Future<UserModel> updateProfile({String? displayName, String? photoUrl}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Utilisateur non connecté');

      if (displayName != null) {
        AppLogger.info('Mise à jour du nom d\'affichage: $displayName');
        await user.updateDisplayName(displayName);
      }
      if (photoUrl != null) {
        AppLogger.info('Mise à jour de la photo de profil');
        await user.updatePhotoURL(photoUrl);
      }

      final userModel = UserModel(uid: user.uid, email: user.email!, displayName: user.displayName);

      AppLogger.info('Profil mis à jour avec succès');
      return userModel;
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de la mise à jour du profil', e, stackTrace);
      rethrow;
    }
  }
}
