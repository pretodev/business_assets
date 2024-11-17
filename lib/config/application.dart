import 'dart:async';
import 'dart:developer';

import 'package:auto_injector/auto_injector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../firebase_options.dart';

typedef AppBuilder = FutureOr<Widget> Function();

typedef AppBind = void Function(AutoInjector injector)?;

final _injector = AutoInjector();

Future<void> buildApp({
  AppBind? bind,
  required AppBuilder builder,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (details) {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    } else {
      log(details.exceptionAsString(), stackTrace: details.stack);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } else {
      log(error.toString(), stackTrace: stack);
    }
    return true;
  };

  bind?.call(_injector);

  _injector.commit();

  final app = await builder();

  runApp(app);
}

mixin ServiceLocatorMixin on Object {
  T instance<T>({Param? Function(Param)? transform, String? key}) {
    return _injector.get<T>(transform: transform, key: key);
  }
}
