import 'package:app/ui/templates/base_page.dart';
import 'package:flutter/material.dart';

class MainScreenTemplate extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBarBottom;

  const MainScreenTemplate({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.appBarBottom,
  });

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: title,
      appBarBottom: appBarBottom,
      body: body,
      actions: actions,
      floatingActionButton: floatingActionButton,
    );
  }
}
