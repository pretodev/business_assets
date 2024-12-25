import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_localizations.dart';

class CustomLocalizationNotifier extends ChangeNotifier {
  CustomLocalizationNotifier() {
    loadLocale();
  }

  static const _storeKey = 'custom_locale';

  CustomLocalizations? _locale;

  CustomLocalizations? get locale => _locale;

  void setLocale(CustomLocalizations locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storeKey, locale.name);
  }

  void loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final locale = prefs.getString(_storeKey);
    _locale = locale != null
        ? //
        CustomLocalizations.values.byName(locale)
        : null;
    notifyListeners();
  }
}

class CustomLocalizationProvider
    extends InheritedNotifier<CustomLocalizationNotifier> {
  CustomLocalizationProvider({
    super.key,
    required super.child,
  }) : super(notifier: CustomLocalizationNotifier());

  static CustomLocalizationNotifier of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CustomLocalizationProvider>()!
        .notifier!;
  }
}
