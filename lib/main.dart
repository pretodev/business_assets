import 'package:flutter/material.dart';

import 'initialize.dart';
import 'ui/screens/home/home_screen.dart';

void main() {
  initializeApp(() async {
    return const BusinessAssetsApp();
  });
}

class BusinessAssetsApp extends StatelessWidget {
  const BusinessAssetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tractian: Business Assets',
      home: HomeScreen(),
    );
  }
}
