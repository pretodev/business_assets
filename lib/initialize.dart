import 'dart:async';

import 'package:flutter/widgets.dart';

typedef InitializeBuilder = FutureOr<Widget> Function();

Future<void> initializeApp(InitializeBuilder builder) async {
  final app = await builder();

  runApp(app);
}
