import 'package:app/sort/user_model.dart';
import 'package:app/core/router/app_router.dart';
import 'package:flutter/foundation.dart';

class RedirectionService {
  RedirectionService();

  Future<String?> getRedirectionUri({
    required Uri uri,
    required String destination,
    UserModel? user,
  }) async {
    if (destination.isEmpty) {
      return null;
    }
    return await _redirectForAuth(uri, destination, user);
  }

  Future<String?> _redirectForAuth(Uri uri, String destination, UserModel? user) async {
    if (noAuthNeededPage.any((element) => RegExp('^\$element\$').hasMatch(destination)) ||
        user != null) {
      return null;
    }
    return Locations.login;
  }
}

@visibleForTesting
const noAuthNeededPage = [
  Locations.errorApi,
  Locations.login,
  Locations.register,
  Locations.welcome,
];
