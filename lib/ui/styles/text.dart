part of './styles.dart';

@immutable
class TextStyles {
  factory TextStyles.theme() {
    return TextStyles(
      appBarTitle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
      ),
      bodyLarger: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  const TextStyles({
    required this.appBarTitle,
    required this.bodyLarger,
    required this.bodyMedium,
    required this.bodySmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
  });

  final TextStyle appBarTitle;
  final TextStyle bodyLarger;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;

  static TextStyles? lerp(TextStyles? a, TextStyles? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return TextStyles(
      appBarTitle: TextStyle.lerp(a?.appBarTitle, b?.appBarTitle, t)!,
      bodyLarger: TextStyle.lerp(a?.bodyLarger, b?.bodyLarger, t)!,
      bodyMedium: TextStyle.lerp(a?.bodyMedium, b?.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(a?.bodySmall, b?.bodySmall, t)!,
      titleLarge: TextStyle.lerp(a?.titleLarge, b?.titleLarge, t)!,
      titleMedium: TextStyle.lerp(a?.titleMedium, b?.titleMedium, t)!,
      titleSmall: TextStyle.lerp(a?.titleSmall, b?.titleSmall, t)!,
    );
  }
}
