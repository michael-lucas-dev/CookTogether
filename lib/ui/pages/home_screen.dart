import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cooktogether/router/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Icon(Icons.restaurant_menu, size: 120),
    Icon(Icons.calendar_today, size: 120),
    Icon(Icons.shopping_cart, size: 120),
    Icon(Icons.people, size: 120),
  ];

  static const List<String> _routeNames = [
    Locations.recipes,
    Locations.planning,
    Locations.shopping,
    Locations.community,
  ];

  static const List<String> _menuTitles = ['Recettes', 'Planning', 'Courses', 'Communauté'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.push(_routeNames[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Recettes'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Planning'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Communauté'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
