import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../styles/styles.dart';
import 'routing/router.dart';

class BusinessAssetsApp extends StatelessWidget {
  const BusinessAssetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router(),
      theme: Styles.theme,
      title: 'Tractian: Business Assets',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        return Localizations.override(
          context: context,
          locale: const Locale('pt'),
          child: child,
        );
      },
    );
  }
}
