import 'package:flutter/material.dart';

import 'config/firebase/firebase_setup.dart';
import 'config/service_locator/service_locator.dart';
import 'config/service_locator/service_locator_provider.dart';
import 'config/setup.dart';
import 'ui/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setup([
    FirebaseSetup(),
  ]);

  runApp(
    ServiceLocatorProvider(
      serviceLocator: ServiceLocator(),
      child: const BusinessAssetsApp(),
    ),
  );
}
