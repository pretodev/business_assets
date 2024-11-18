part of './styles.dart';

@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  factory AppTextStyles.custom() => AppTextStyles(
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

  const AppTextStyles({
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

  @override
  ThemeExtension<AppTextStyles> copyWith({
    TextStyle? appBarTitle,
    TextStyle? bodyLarger,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
  }) {
    return AppTextStyles(
      appBarTitle: appBarTitle ?? this.appBarTitle,
      bodyLarger: bodyLarger ?? this.bodyLarger,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
    );
  }

  @override
  ThemeExtension<AppTextStyles> lerp(covariant AppTextStyles other, double t) {
    return AppTextStyles(
      appBarTitle: TextStyle.lerp(appBarTitle, other.appBarTitle, t)!,
      bodyLarger: TextStyle.lerp(bodyLarger, other.bodyLarger, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t)!,
    );
  }
}
