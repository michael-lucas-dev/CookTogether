import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../domain/user.dart';
import '../domain/user_repository.dart';
import '../data/firestore_user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return FirestoreUserRepository();
});

/// Utilisateur connecté + ses données Firestore
@riverpod
Future<AppUser?> currentUser(CurrentUserRef ref) async {
  final authUser = await ref.watch(authNotifierProvider.future);
  if (authUser == null) return null;

  final repo = ref.watch(userRepositoryProvider);
  return await repo.getUser(authUser.uid);
}
