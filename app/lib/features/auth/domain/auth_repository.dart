import '../domain/auth_user.dart';

abstract class AuthRepository {
  Stream<AuthUser?> authStateChanges();
  Future<void> signOut();
  Future<AuthUser?> signInWithEmailAndPassword({required String email, required String password});
  Future<AuthUser?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> sendPasswordResetEmail(String email);
}
