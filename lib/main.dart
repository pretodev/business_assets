import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'config/firebase/firebase_setup.dart';
import 'config/setup.dart';
import 'ui/screens/companies_screen.dart';
import 'ui/styles/styles.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setup([
    FirebaseSetup(),
  ]);
}

class BusinessAssetsApp extends StatelessWidget {
  const BusinessAssetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const CompaniesScreen(),
      theme: AppStyle().theme,
      title: 'Tractian: Business Assets',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
