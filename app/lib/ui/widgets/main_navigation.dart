import 'package:app/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigationBottomBar extends StatelessWidget {
  const MainNavigationBottomBar({super.key});

  static const tabs = [
    Locations.recipes,
    Locations.planning,
    Locations.shopping,
    Locations.community,
  ];

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    int currentIndex = tabs.indexWhere((tab) => location.startsWith(tab));
    if (currentIndex == -1) currentIndex = 0;
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Recettes'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Planning'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Courses'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Communauté'),
      ],
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFF4CAF50),
      onTap: (index) {
        context.go(tabs[index]);
      },
    );
  }
}
