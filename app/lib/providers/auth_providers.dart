import 'package:app/models/user_model.dart';
import 'package:app/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<UserModel?>((ref) {
  final auth = ref.watch(authServiceProvider);
  return auth.user;
});

final authStateUserProvider = StateProvider<UserModel?>((ref) => null);
  