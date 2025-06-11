import 'package:cooktogether/ui/templates/base_page.dart';
import 'package:flutter/material.dart';

class MainScreenTemplate extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const MainScreenTemplate({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: title,
      body: body,
      actions: actions,
      floatingActionButton: floatingActionButton,
    );
  }
}
