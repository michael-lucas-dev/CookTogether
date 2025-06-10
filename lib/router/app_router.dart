import 'package:cooktogether/core/logger.dart';
import 'package:cooktogether/providers/auth_providers.dart';
import 'package:cooktogether/ui/pages/auth/login_screen.dart';
import 'package:cooktogether/ui/pages/auth/register_screen.dart';
import 'package:cooktogether/ui/pages/recipes/recipe_list_screen.dart';
import 'package:cooktogether/ui/widgets/auth_state_handler.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final user = ref.read(authStateProvider).value;
      final isLoggingIn = state.fullPath == '/login' || state.fullPath == '/register';

      if (user == null && !isLoggingIn) {
        AppLogger.info('Redirection vers /login car non connecté');
        return '/login';
      } else if (user != null && isLoggingIn) {
        AppLogger.info('Redirection vers /home car connecté');
        return '/home';
      }
      return null;
    },

    routes: [
      GoRoute(path: '/', name: 'auth', builder: (context, state) => const AuthStateHandler()),
      GoRoute(path: '/login', name: 'login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/recipes',
        name: 'recipes',
        builder: (context, state) => const RecipeListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'recipe_detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return Text('RecipeDetailScreen(recipeId: $id)');
            },
          ),
        ],
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
    errorBuilder: (context, state) {
      AppLogger.error('Route non trouvée', state.error);
      return Scaffold(body: Center(child: Text('Page non trouvée')));
    },
    observers: [NavigationMiddlewareObserver()],
  );
});

class NavigationMiddlewareObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      AppLogger.info('Route poussée: ${route.settings.name}');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      AppLogger.info('Route pop: ${route.settings.name}');
    }
  }
}
