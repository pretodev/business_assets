import 'package:flutter/material.dart';

part 'colors.dart';
part 'extensions.dart';
part 'text.dart';

@immutable
class Styles extends ThemeExtension<Styles> {
  static ThemeData get theme {
    final text = TextStyles.theme();
    final colors = ColorStyles.theme();
    return ThemeData(
      scaffoldBackgroundColor: colors.scaffoldBackground,
      appBarTheme: AppBarTheme(
        elevation: 0,
        titleTextStyle: text.appBarTitle.copyWith(
          color: colors.textOnSecondary,
        ),
        backgroundColor: colors.secondary,
        iconTheme: IconThemeData(
          color: colors.textOnSecondary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colors.inputBackground,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 6.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: colors.inputBackground, width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: colors.secondary, width: 0.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: colors.inputBackground, width: 0.0),
        ),
        hintStyle: text.bodyMedium.copyWith(
          color: colors.textTertiary,
        ),
        labelStyle: text.bodyMedium,
        prefixIconColor: colors.textTertiary,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
        ),
        textStyle: text.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: colors.primary,
        ),
      ),
      extensions: [Styles._(text: text, colors: colors)],
    );
  }

  const Styles._({
    required this.text,
    required this.colors,
  });

  final TextStyles text;
  final ColorStyles colors;

  @override
  ThemeExtension<Styles> copyWith({
    TextStyles? text,
    ColorStyles? colors,
  }) {
    return Styles._(
      text: text ?? this.text,
      colors: colors ?? this.colors,
    );
  }

  @override
  ThemeExtension<Styles> lerp(covariant Styles? other, double t) {
    return Styles._(
      text: TextStyles.lerp(text, other?.text, t)!,
      colors: ColorStyles.lerp(colors, other?.colors, t)!,
    );
  }
}
