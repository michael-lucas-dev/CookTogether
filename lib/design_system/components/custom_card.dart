import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final double borderRadius;

  const CustomCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.onTap,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: backgroundColor ?? Colors.white,
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}
