import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final double? height;
  final double? width;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.height,
    this.width,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: textColor ?? Colors.black,
                side: BorderSide(color: backgroundColor ?? Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 12),
                ),
              ),
              child: Text(text),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? const Color(0xFF4CAF50),
                foregroundColor: textColor ?? Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 12),
                ),
              ),
              child: Text(text),
            ),
    );
  }
}
