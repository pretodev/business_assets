part of './styles.dart';

class AppColors extends ThemeExtension<AppColors> {
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

  const AppColors({
    this.primary = const Color(0xFF2188FF),
    this.secondary = const Color(0xFF17192D),
    this.textOnPrimary = const Color(0xFFFFFFFF),
    this.textOnSecondary = const Color(0xFFFFFFFF),
    this.scaffoldBackground = const Color(0xFFFFFFFF),
    this.inputBackground = const Color(0xFFEAEFF3),
    this.textPrimary = const Color(0xFF17192D),
    this.textSecondary = const Color(0xFF77818C),
    this.textTertiary = const Color(0xFF8E98A3),
    this.border = const Color(0xFFD8DFE6),
  });

  @override
  ThemeExtension<AppColors> copyWith({
    Color? primary,
    Color? secondary,
    Color? textOnPrimary,
    Color? textOnSecondary,
    Color? scaffoldBackground,
    Color? inputBackground,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? border,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      textOnSecondary: textOnSecondary ?? this.textOnSecondary,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      inputBackground: inputBackground ?? this.inputBackground,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      border: border ?? this.border,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    return copyWith(
      primary: Color.lerp(primary, other.primary, t),
      secondary: Color.lerp(secondary, other.secondary, t),
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t),
      textOnSecondary: Color.lerp(textOnSecondary, other.textOnSecondary, t),
      scaffoldBackground:
          Color.lerp(scaffoldBackground, other.scaffoldBackground, t),
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t),
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t),
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t),
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t),
      border: Color.lerp(border, other.border, t),
    );
  }
}
