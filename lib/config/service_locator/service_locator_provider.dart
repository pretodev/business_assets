import 'package:flutter/material.dart';

import 'service_locator.dart';

class ServiceLocatorProvider extends InheritedWidget {
  final ServiceLocator serviceLocator;

  const ServiceLocatorProvider({
    super.key,
    required this.serviceLocator,
    required super.child,
  });

  static ServiceLocatorProvider of(BuildContext context) {
    final ServiceLocatorProvider? result =
        context.dependOnInheritedWidgetOfExactType<ServiceLocatorProvider>();
    assert(result != null, 'No InjectorInheritedWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ServiceLocatorProvider oldWidget) =>
      serviceLocator != oldWidget.serviceLocator;
}

extension AppModuleExtension on BuildContext {
  T get<T>() => ServiceLocatorProvider.of(this).serviceLocator.get<T>();
}
