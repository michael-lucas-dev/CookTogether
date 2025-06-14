enum ButtonVariant {
  elevatedPrimary(ButtonType.elevated, ColorVariant.primary),
  elevatedSecondary(ButtonType.elevated, ColorVariant.secondary),
  outlinedPrimary(ButtonType.outlined, ColorVariant.primary),
  outlinedSecondary(ButtonType.outlined, ColorVariant.secondary),
  textPrimary(ButtonType.text, ColorVariant.primary),
  textSecondary(ButtonType.text, ColorVariant.secondary);

  final ButtonType type;
  final ColorVariant color;

  const ButtonVariant(this.type, this.color);
}

enum ColorVariant {
  primary,
  secondary,
}

enum ButtonType{
  elevated,
  outlined,
  text,
}

enum ButtonSize { small, medium }
