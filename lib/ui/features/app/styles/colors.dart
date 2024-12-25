part of 'styles.dart';

@immutable
class ColorStyles {
  factory ColorStyles.theme() {
    return ColorStyles(
      primary: const Color(0xFF2188FF),
      secondary: const Color(0xFF17192D),
      textOnPrimary: const Color(0xFFFFFFFF),
      textOnSecondary: const Color(0xFFFFFFFF),
      scaffoldBackground: const Color(0xFFFFFFFF),
      inputBackground: const Color(0xFFEAEFF3),
      textPrimary: const Color(0xFF17192D),
      textSecondary: const Color(0xFF77818C),
      textTertiary: const Color(0xFF8E98A3),
      border: const Color(0xFFD8DFE6),
    );
  }

  const ColorStyles({
    required this.primary,
    required this.secondary,
    required this.textOnPrimary,
    required this.textOnSecondary,
    required this.scaffoldBackground,
    required this.inputBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
  });

  final Color primary;
  final Color secondary;
  final Color textOnPrimary;
  final Color textOnSecondary;
  final Color scaffoldBackground;
  final Color inputBackground;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;

  static ColorStyles? lerp(ColorStyles? a, ColorStyles? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return ColorStyles(
      primary: Color.lerp(a?.primary, b?.primary, t)!,
      secondary: Color.lerp(a?.secondary, b?.secondary, t)!,
      textOnPrimary: Color.lerp(a?.textOnPrimary, b?.textOnPrimary, t)!,
      textOnSecondary: Color.lerp(a?.textOnSecondary, b?.textOnSecondary, t)!,
      scaffoldBackground:
          Color.lerp(a?.scaffoldBackground, b?.scaffoldBackground, t)!,
      inputBackground: Color.lerp(a?.inputBackground, b?.inputBackground, t)!,
      textPrimary: Color.lerp(a?.textPrimary, b?.textPrimary, t)!,
      textSecondary: Color.lerp(a?.textSecondary, b?.textSecondary, t)!,
      textTertiary: Color.lerp(a?.textTertiary, b?.textTertiary, t)!,
      border: Color.lerp(a?.border, b?.border, t)!,
    );
  }
}
