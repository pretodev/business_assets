import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/uid.dart';
import '../../assets/widgets/assets_screen.dart';
import '../../companies/widgets/companies_screen.dart';
import 'routes.dart';

GoRouter router({GlobalKey<NavigatorState>? navigatorKey}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: Routes.companies,
    routes: [
      GoRoute(
        path: Routes.companies,
        builder: (context, state) {
          return const CompaniesScreen();
        },
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              return AssetsScreen(
                companyId: Uid.fromString(state.pathParameters['id']!),
              );
            },
          ),
        ],
      ),
    ],
  );
}
