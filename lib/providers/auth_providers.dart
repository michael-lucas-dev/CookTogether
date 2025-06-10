import 'package:cooktogether/models/user_model.dart';
import 'package:cooktogether/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<UserModel?>((ref) {
  final auth = ref.watch(authServiceProvider);
  return auth.user;
});

final authStateUserProvider = StateProvider<UserModel?>((ref) => null);
  