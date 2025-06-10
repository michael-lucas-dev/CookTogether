import 'package:cooktogether/models/user_model.dart';
import 'package:cooktogether/router/app_router.dart';
import 'package:flutter/foundation.dart';

class RedirectionService {
  RedirectionService();

  /// Recuperation de la redirection
  ///
  /// [uri] Uri de la page
  /// [destination] Destination de la redirection
  ///
  /// Retourne l'url de redirection, null si pas de redirection à effectuer
  Future<String?> getRedirectionUri({required Uri uri, required String destination, UserModel? user}) async {
    if (destination.isEmpty) {
      return null;
    }
    return //await _redirectForControleEtatApplication(uri) ??
    await _redirectForAuth(uri, destination, user) ?? await _redirectAfterAuth(uri, destination, user);
  }

  /// Redirige vers l'écran retourné par le service controleEtatApplication, pour permettre de bloquer l'accès à l'application si besoin
  /// Ce contrôle est uniquement fait à la 1ere redirection, une fois cet accès validé on ne le refait pas
  /*Future<String?> _redirectForControleEtatApplication(Uri uri) async {
    if (uri.toString().contains(Locations.authentificationRedirectUri)) {
      isControleEtatApplicationNotAlreadyChecked = false;
    }

    if (isControleEtatApplicationNotAlreadyChecked) {
      isControleEtatApplicationNotAlreadyChecked = false;
      final path = uri.toString().replaceFirst(
        "${environment.maifSchemeDeeplink}://${environment.maifHostDeeplink}",
        "",
      );
      return "${Locations.controleEtatApplication}?${QueryParameters.destination.value}=$path";
    }
    return null;
  }*/

  /// Redirection vers l'authentification si necessaire
  ///
  /// [uri] Uri de la page
  /// [destination] Destination souhaitée
  ///
  /// Retourne l'url vers l'authentification, null si pas d'authentification a effectuer
  Future<String?> _redirectForAuth(Uri uri, String destination, UserModel? user) async {
    // Pas besoin d'auhtentification
    if (noAuthNeededPage.any((element) => RegExp('^\\$element\$').hasMatch(destination)) ||
        user != null) {
      return null;
    } else {
      return Locations.login;
    }
  }

  /// Redirection vers les consentements (CGU et collecte de données), l'écran de notification
  /// et l'écran biométrie
  ///
  /// [uri] Uri de la page
  /// [destination] Destination souhaitée
  ///
  /// Retourne l'url vers :
  ///   - les consentements si il ne les a pas déjà accepté
  ///   - l'écran de notifications si l'on ne lui a pas encore présenté dans l'app
  ///   - l'écran de biométrie si l'appareil en est équipé et qu'on ne lui a pas encore demandé
  ///   - null dans tout les autres cas (pas de redirection)
  Future<String?> _redirectAfterAuth(Uri uri, String destination, UserModel? user) async {
    return null;
  }
}

@visibleForTesting
const noAuthNeededPage = [
  //Locations.controleEtatApplication,
  Locations.errorApi,
  Locations.login,
  Locations.register,
  Locations.welcome,
];
