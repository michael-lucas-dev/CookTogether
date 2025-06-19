import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({required String uid, required String pseudo, String? avatarUrl}) =
      _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(uid: uid, pseudo: data['pseudo'] ?? 'Utilisateur', avatarUrl: data['avatarUrl']);
  }
}

extension AppUserMap on AppUser {
  Map<String, dynamic> toMap() => toJson();
}
