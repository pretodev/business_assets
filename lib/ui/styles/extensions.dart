part of './styles.dart';

extension ColorFilterOnColor on Color {
  ColorFilter get colorFilter => ColorFilter.mode(this, BlendMode.srcIn);
}

extension AppStyleExtension on BuildContext {
  Styles get styles {
    return Theme.of(this).extension<Styles>()!;
  }
}
