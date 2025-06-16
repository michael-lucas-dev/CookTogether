import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage;

  StorageService(this._storage);

  /// Upload a file to the given [path] in Firebase Storage and return its download URL.
  Future<String> uploadFile({
    required File file,
    required String path,
  }) async {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putFile(file);
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
