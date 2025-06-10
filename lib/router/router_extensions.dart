import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension GoRouterExtension on BuildContext {
  // Navigation de base
  void goNamed(
    String name, {
    Map<String, String> params = const {},
    Map<String, dynamic> query = const {},
  }) {
    GoRouter.of(this).goNamed(name, pathParameters: params, queryParameters: query);
  }

  void pushNamed(
    String name, {
    Map<String, String> params = const {},
    Map<String, dynamic> query = const {},
  }) {
    GoRouter.of(this).pushNamed(name, pathParameters: params, queryParameters: query);
  }

  void pop<T extends Object?>([T? result]) {
    GoRouter.of(this).pop(result);
  }

  // Méthodes spécifiques à l'application
  void goToLogin() => goNamed('login');
  void goToRecipes() => goNamed('recipes');
  void goToRecipeDetail(String id) => goNamed('recipe_detail', params: {'id': id});

  // Gestion des redirections
  bool get canPop => GoRouter.of(this).canPop();

  // Gestion des paramètres
  Map<String, String> get pathParams => GoRouterState.of(this).pathParameters;
  Map<String, dynamic> get queryParams => GoRouterState.of(this).uri.queryParameters;
}
