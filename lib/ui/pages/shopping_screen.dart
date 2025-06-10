import 'package:flutter/material.dart';
import 'package:cooktogether/ui/templates/main_screen_template.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScreenTemplate(
      title: 'Courses',
      body: const Center(child: Text('Courses')),
    );
  }
}
