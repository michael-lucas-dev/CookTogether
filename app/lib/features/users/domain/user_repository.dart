import '../domain/user.dart';

abstract class UserRepository {
  Future<AppUser?> getUser(String uid);
  Future<void> createUser(AppUser user);
  Future<void> updateUser(AppUser user);
  Future<void> deleteUser(String uid);
}
