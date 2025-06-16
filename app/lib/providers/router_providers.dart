// Créons un Provider pour la logique de redirection
import 'package:app/core/logger.dart';
import 'package:app/providers/auth_providers.dart';
import 'package:app/router/app_router.dart';
import 'package:app/services/redirection_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final redirectProvider = Provider<Function(BuildContext, GoRouterState)>((ref) {
  return (context, state) {
    final user = ref.watch(authStateUserProvider);
    final isLoggingIn = state.fullPath == '/login' || state.fullPath == '/register';

    if (user == null && !isLoggingIn) {
      AppLogger.info('Redirection vers /login car non connecté');
      return '/login';
    } else if (user != null && isLoggingIn) {
      AppLogger.info('Redirection vers /home car connecté');
      return '/home';
    }
    return null;
  };
});

final redirectionServiceProvider = Provider((ref) => RedirectionService());

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    // Écoute les changements d'état d'authentification
    _ref.listen(authStateProvider, (previous, current) {
      debugPrint('Auth state changed: $previous -> $current');
      notifyListeners();
    });
  }

  Future<String?> redirectLogic(BuildContext context, GoRouterState state) async {
    final authState = _ref.read(authStateProvider);
    final redirectionService = _ref.read(redirectionServiceProvider);

    return authState.when(
      data: (user) async {
        debugPrint('Auth state check: $user');
        // Pour la première arrivée sur l'app
        if (state.uri.toString() == Locations.welcome) {
          if (user == null) {
            AppLogger.info('Redirection vers /login car utilisateur non connecté');
            return Locations.login;
          } else {
            AppLogger.info('Redirection vers /recipes car utilisateur connecté');
            return Locations.recipes;
          }
        }

        // Pour les autres routes, utiliser le service de redirection
        final uri = Uri.parse(state.uri.toString());
        final destination = state.uri.toString();

        final redirectionUri = await redirectionService.getRedirectionUri(
          uri: uri,
          destination: destination,
          user: user,
        );

        if (redirectionUri != null) {
          AppLogger.info('Redirection vers: $redirectionUri');
          return redirectionUri;
        }

        return null;
      },
      loading: () {
        debugPrint('Auth state loading');
        return null;
      },
      error: (error, stackTrace) {
        AppLogger.error('Erreur lors de la redirection', error, stackTrace);
        return Locations.login;
      },
    );
  }
}
