import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'localization/custom_localization.dart';
import 'localization/custom_localization_widget.dart';
import 'routing/router.dart';
import 'styles/styles.dart';

class BusinessAssetsApp extends StatelessWidget {
  const BusinessAssetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomLocalizationProvider(
      child: MaterialApp.router(
        routerConfig: router(),
        theme: Styles.theme,
        title: 'Tractian: Business Assets',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) {
          return AnnotatedRegion(
            value: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).appBarTheme.backgroundColor,
              statusBarIconBrightness: Brightness
                  .light, // ou Brightness.dark, dependendo do seu tema
            ),
            child: CustomLocalizationOverride(
              child: child ?? const SizedBox(),
            ),
          );
        },
      ),
    );
  }
}
