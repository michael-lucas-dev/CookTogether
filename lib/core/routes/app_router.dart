import 'package:cooktogether/features/auth/presentation/screens/login_screen.dart';
import 'package:cooktogether/features/recipes/presentation/screens/recipe_detail_screen.dart';
import 'package:cooktogether/features/recipes/presentation/screens/recipe_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:cooktogether/features/auth/presentation/screens/login_screen.dart';
//import 'package:cooktogether/features/recipes/presentation/screens/recipe_list_screen.dart';
//import 'package:cooktogether/features/recipes/presentation/screens/recipe_detail_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
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
              return RecipeDetailScreen(recipeId: id);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page non trouvée: ${state.uri.path}'))),
    redirect: (context, state) {
      // Ici vous pouvez ajouter votre logique de redirection basée sur l'authentification
      // Par exemple :
      // final isLoggedIn = context.read(authProvider).isAuthenticated;
      // final isLoggingIn = state.uri.path == '/login';
      // if (!isLoggedIn) return isLoggingIn ? null : '/login';
      // if (isLoggingIn) return '/recipes';
      return null;
    },
  );
}
