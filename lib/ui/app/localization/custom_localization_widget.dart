import 'package:flutter/material.dart';

import 'custom_localization.dart';

class CustomLocalizationOverride extends StatelessWidget {
  const CustomLocalizationOverride({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: CustomLocalizationProvider.of(context),
      builder: (context, child) {
        final locale = CustomLocalizationProvider.of(context).locale;
        if (locale == null) {
          return child!;
        }
        return Localizations.override(
          context: context,
          locale: Locale(locale.name),
          child: child,
        );
      },
      child: child,
    );
  }
}
