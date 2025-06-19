import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  StorageService(this._storage, this._auth);

  /// Upload a file to the given [path] in Firebase Storage and return its download URL.
  Future<String> uploadFile({
    required File file,
    required String path,
    bool isPublic = true,
  }) async {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putFile(
      file,
      SettableMetadata(
        customMetadata: {'ownerId': _auth.currentUser!.uid, 'isPublic': isPublic.toString()},
      ),
    );
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  /// Delete a file from Firebase Storage by its [url].
  Future<void> deleteFileByUrl(String url) async {
    final ref = _storage.refFromURL(url);
    await ref.delete();
  }
}
