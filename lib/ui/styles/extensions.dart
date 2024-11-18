part of './styles.dart';

extension ColorFilterOnColor on Color {
  ColorFilter get colorFilter => ColorFilter.mode(this, BlendMode.srcIn);
}

extension AppStyleExtension on BuildContext {
  AppColors get appColors {
    return Theme.of(this).extension<AppColors>()!;
  }

  AppTextStyles get appTextStyles {
    return Theme.of(this).extension<AppTextStyles>()!;
  }
}
