import 'package:app/core/logger.dart';
import 'package:app/features/users/domain/user.dart';
import 'package:app/features/users/providers/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/auth_user.dart';
import '../domain/auth_repository.dart';
import '../data/firebase_auth_repository.dart';

part 'auth_provider.g.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Stream<AuthUser?> build() {
    return ref.watch(authRepositoryProvider).authStateChanges();
  }

  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
    state = AsyncLoading();
    final user = await ref
        .read(authRepositoryProvider)
        .signInWithEmailAndPassword(email: email, password: password);
    state = AsyncData(user);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = AsyncLoading();

    final authRepo = ref.read(authRepositoryProvider);
    final userRepo = ref.read(userRepositoryProvider);

    final authUser = await authRepo.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = AppUser(uid: authUser!.uid, pseudo: displayName);
    await userRepo.createUser(user);
    state = AsyncData(authUser);
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      AppLogger.info('Tentative d\'envoi de réinitialisation de mot de passe pour: $email');
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
      AppLogger.info('Email de réinitialisation envoyé avec succès');
    } catch (e, stackTrace) {
      AppLogger.error('Erreur lors de l\'envoi de l\'email de réinitialisation', e, stackTrace);
      rethrow;
    }
  }
}
