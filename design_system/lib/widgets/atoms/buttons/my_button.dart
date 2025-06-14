import 'package:flutter/material.dart';

import 'enums.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  const MyButton._({
    required this.text,
    this.onPressed,
    required this.variant,
    this.isLoading = false,
    this.icon,
  });

  factory MyButton.elevatedPrimary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
  }) => MyButton._(
    text: text,
    onPressed: onPressed,
    icon: icon,
    isLoading: isLoading,
    variant: ButtonVariant.elevatedPrimary,
  );

  factory MyButton.elevatedSecondary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
  }) => MyButton._(
    text: text,
    onPressed: onPressed,
    icon: icon,
    isLoading: isLoading,
    variant: ButtonVariant.elevatedSecondary,
  );

  factory MyButton.outlinedPrimary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
  }) => MyButton._(
    text: text,
    onPressed: onPressed,
    icon: icon,
    isLoading: isLoading,
    variant: ButtonVariant.outlinedPrimary,
  );

  factory MyButton.outlinedSecondary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
  }) => MyButton._(
    text: text,
    onPressed: onPressed,
    icon: icon,
    isLoading: isLoading,
    variant: ButtonVariant.outlinedSecondary,
  );

  factory MyButton.textPrimary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
  }) => MyButton._(
    text: text,
    onPressed: onPressed,
    icon: icon,
    isLoading: isLoading,
    variant: ButtonVariant.textPrimary,
  );

  factory MyButton.textSecondary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
  }) => MyButton._(
    text: text,
    onPressed: onPressed,
    icon: icon,
    isLoading: isLoading,
    variant: ButtonVariant.textSecondary,
  );

  @override
  Widget build(BuildContext context) {
    Widget child =
        isLoading
            ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
            : Text(text);

    if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16), const SizedBox(width: 8), child],
      );
    }

    switch (variant) {
      case ButtonVariant.elevatedPrimary:
      case ButtonVariant.elevatedSecondary:
        return ElevatedButton(
          onPressed: onPressed,
          //style: buttonStyle as ButtonStyle?,
          child: child,
        );
      case ButtonVariant.outlinedPrimary:
      case ButtonVariant.outlinedSecondary:
        return OutlinedButton(onPressed: onPressed, child: child);
      case ButtonVariant.textPrimary:
      case ButtonVariant.textSecondary:
        return TextButton(onPressed: onPressed, child: child);
    }
  }
}
