import 'package:flutter/material.dart';

enum TextFieldVariant {
  filled,
  outlined,
}

class MyTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final int? maxLines;
  final Function(String)? onChanged;
  final TextFieldVariant variant;

  const MyTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.validator,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.onChanged,
    this.variant = TextFieldVariant.outlined,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: variant == TextFieldVariant.outlined
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(color: Colors.grey),
              )
            : null,
        filled: variant == TextFieldVariant.filled,
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}
