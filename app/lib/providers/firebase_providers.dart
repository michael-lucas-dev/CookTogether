import 'package:app/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(FirebaseAuth.instance);
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService(FirebaseFirestore.instance);
});

final storageServiceProvider = Provider<StorageService>((ref) {
    return StorageService(FirebaseStorage.instance);
});
