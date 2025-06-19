import 'package:app/features/auth/domain/auth_repository.dart';
import 'package:app/features/auth/domain/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<AuthUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_userToAuthUser);
  }

  @override
  Future<AuthUser?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userCred = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCred.user!;

    return AuthUser(uid: user.uid, email: user.email, isAnonymous: user.isAnonymous);
  }

  @override
  Future<AuthUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userCred = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCred.user!;

    return AuthUser(uid: user.uid, email: user.email, isAnonymous: user.isAnonymous);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  AuthUser? _userToAuthUser(User? user) {
    if (user == null) return null;
    return AuthUser(uid: user.uid, email: user.email, isAnonymous: user.isAnonymous);
  }
}
