import 'package:app/core/logger.dart';
import 'package:app/sort/firebase_providers.dart';
import 'package:app/ui/widgets/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasePage extends ConsumerWidget {
  final String title;
  final PreferredSizeWidget? appBarBottom;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBottomNav;
  final Widget? floatingActionButton;

  const BasePage({
    super.key,
    required this.title,
    required this.body,
    this.appBarBottom,
    this.actions,
    this.leading,
    this.showBottomNav = false,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading:
            leading ??
            (context.canPop()
                ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop())
                : null),
        title: Text(title),
        bottom: appBarBottom,
        actions: [
          ...?actions,
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                AppLogger.info('Déconnexion en cours');
                await ref.read(authServiceProvider).signOut();
                AppLogger.info('Déconnexion réussie');
              } catch (e, stackTrace) {
                AppLogger.error('Erreur lors de la déconnexion', e, stackTrace);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Erreur: ${e.toString()}')));
              }
            },
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: showBottomNav ? const MainNavigationBottomBar() : null,
      floatingActionButton: floatingActionButton,
    );
  }

  BasePage copyWith({
    String? title,
    Widget? body,
    PreferredSizeWidget? appBarBottom,
    List<Widget>? actions,
    Widget? leading,
    bool? showBottomNav,
    Widget? floatingActionButton,
  }) {
    return BasePage(
      title: title ?? this.title,
      body: body ?? this.body,
      appBarBottom: appBarBottom ?? this.appBarBottom,
      actions: actions ?? this.actions,
      leading: leading ?? this.leading,
      showBottomNav: showBottomNav ?? this.showBottomNav,
      floatingActionButton: floatingActionButton ?? this.floatingActionButton,
    );
  }
}
