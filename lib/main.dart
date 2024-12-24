import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'config/dependencies.dart';
import 'config/firebase/firebase_setup.dart';
import 'config/setup.dart';
import 'ui/features/companies/companies_view_model.dart';
import 'ui/features/companies/widgets/companies_screen.dart';
import 'ui/styles/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setup([
    FirebaseSetup(),
  ]);

  runApp(
    MultiProvider(
      providers: providers,
      child: const BusinessAssetsApp(),
    ),
  );
}

class BusinessAssetsApp extends StatelessWidget {
  const BusinessAssetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CompaniesScreen(
        viewModel: CompaniesViewModel(
          companyRepository: context.read(),
        ),
      ),
      theme: Styles.theme,
      title: 'Tractian: Business Assets',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
