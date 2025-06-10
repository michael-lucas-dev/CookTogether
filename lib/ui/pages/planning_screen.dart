import 'package:flutter/material.dart';
import 'package:cooktogether/ui/templates/main_screen_template.dart';

class PlanningScreen extends StatelessWidget {
  const PlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScreenTemplate(
      title: 'Planning',
      body: const Center(child: Text('Planning')),
    );
  }
}
