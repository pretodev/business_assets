import 'package:flutter/material.dart';

enum Languages {
  en,
  es,
  pt,
}

class LanguageState extends ValueNotifier<Languages> {
  LanguageState() : super(Languages.pt);

  void load() {}
}
