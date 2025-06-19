import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  UserModel({required this.uid, required this.email, this.displayName, this.photoUrl});

  factory UserModel.fromFirebase(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'displayName': displayName, 'photoUrl': photoUrl};
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email, 'displayName': displayName, 'photoUrl': photoUrl};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
    );
  }
}
