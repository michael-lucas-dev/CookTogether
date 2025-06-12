import 'package:cooktogether/core/logger.dart';
import 'package:cooktogether/providers/router_providers.dart';
import 'package:cooktogether/ui/screens/recipes/edit_recipe_screen.dart';
import 'package:cooktogether/ui/widgets/main_navigation.dart';
import 'package:cooktogether/ui/screens/auth/login_screen.dart';
import 'package:cooktogether/ui/screens/auth/register_screen.dart';
import 'package:cooktogether/ui/screens/auth/welcome_screen.dart';
import 'package:cooktogether/ui/screens/community/community_screen.dart';
import 'package:cooktogether/ui/screens/planning/planning_screen.dart';
import 'package:cooktogether/ui/screens/recipes/add_recipe_screen.dart';
import 'package:cooktogether/ui/screens/recipes/recipe_detail_screen.dart';
import 'package:cooktogether/ui/screens/recipes/recipe_list_screen.dart';
import 'package:cooktogether/ui/screens/shopping/shopping_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Locations {
  static const accueilConnecte = "/home";
  static const errorApi = "/generic_error";
  static const login = "/login";
  static const register = "/register";
  static const recipes = "/recipes";
  static const planning = "/planning";
  static const shopping = "/shopping";
  static const community = "/community";
  static const welcome = "/welcome";
  static const addRecipe = "${Locations.recipes}/add";
  static const recipeDetail = "${Locations.recipes}/detail";
  static const editRecipe = "${Locations.recipes}/edit";

  Locations._();
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Locations.welcome,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: router,
    redirect: router.redirectLogic,

    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return Scaffold(body: child, bottomNavigationBar: const MainNavigationBottomBar());
        }, // Conteneur de la BottomNav

        routes: [
          GoRoute(path: Locations.planning, builder: (context, state) => const PlanningScreen()),
          GoRoute(path: Locations.shopping, builder: (context, state) => const ShoppingScreen()),
          GoRoute(path: Locations.community, builder: (context, state) => const CommunityScreen()),
          GoRoute(path: Locations.recipes, builder: (context, state) => const RecipeListScreen()),
        ],
      ),

      GoRoute(path: Locations.welcome, builder: (context, state) => const WelcomeScreen()),
      GoRoute(path: Locations.login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: Locations.register, builder: (context, state) => const RegisterScreen()),
      GoRoute(path: Locations.addRecipe, builder: (context, state) => const AddRecipeScreen()),
      GoRoute(
        path: "${Locations.recipeDetail}/:recipeId",
        builder: (context, state) {
          final recipeId = state.pathParameters['recipeId']!;
          return RecipeDetailScreen(recipeId: recipeId);
        },
      ),
      GoRoute(
        path: "${Locations.editRecipe}/:recipeId",
        builder: (context, state) {
          final recipeId = state.pathParameters['recipeId']!;
          return EditRecipeScreen(recipeId: recipeId);
        },
      ),
    ],
    errorBuilder: (context, state) {
      AppLogger.error('Route non trouvée', state.error);
      return Scaffold(
        body: SafeArea(
          child: Expanded(
            child: Center(
              child: Column(
                children: [
                  Text('Page non trouvée'),
                  ElevatedButton(child: Text("pop"), onPressed: () => context.pop()),
                ],
              ),
            ),
          ),
        ),
      );
    },
    observers: [NavigationMiddlewareObserver()],
  );
});

class NavigationMiddlewareObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      AppLogger.info('Route push: ${route.settings.name} - args: ${route.settings.arguments}');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route.settings.name != null) {
      AppLogger.info('Route pop: ${route.settings.name} - args: ${route.settings.arguments}');
    }
  }
}
