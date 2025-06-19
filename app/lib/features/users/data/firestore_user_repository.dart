import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/user.dart';
import '../domain/user_repository.dart';

class FirestoreUserRepository implements UserRepository {
  final _users = FirebaseFirestore.instance.collection('users');

  @override
  Future<void> createUser(AppUser user) async {
    await _users.doc(user.uid).set(user.toMap());
  }

  @override
  Future<AppUser?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(uid, doc.data()!);
  }

  @override
  Future<void> updateUser(AppUser user) async {
    await _users.doc(user.uid).update(user.toMap());
  }

  @override
  Future<void> deleteUser(String uid) async {
    await _users.doc(uid).delete();
  }
}
