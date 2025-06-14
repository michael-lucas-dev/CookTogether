import 'package:flutter/material.dart';
import 'package:app/ui/templates/main_screen_template.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScreenTemplate(title: 'Communauté', body: const Center(child: Text('Communauté')));
  }
}
