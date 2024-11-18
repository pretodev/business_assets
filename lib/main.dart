import 'package:flutter/material.dart';

import 'config/application.dart';
import 'config/tractan/tractan_http_client.dart';
import 'domain/company/company_repository.dart';
import 'domain/company_asset/company_asset_repository.dart';
import 'domain/company_location/company_location_repository.dart';
import 'infra/repositories/tractian_company_asset_repository.dart';
import 'infra/repositories/tractian_company_location_repository.dart';
import 'infra/repositories/tractian_company_repository.dart';
import 'ui/screens/companies_screen.dart';

void main() {
  buildApp(
    bind: (i) {
      i.addLazySingleton(TractanHttpClient.new);
      i.addLazySingleton<CompanyLocationRepository>(
        TractianCompanyLocationRepository.new,
      );
      i.addLazySingleton<CompanyAssetRepository>(
        TractianCompanyAssetRepository.new,
      );
      i.addLazySingleton<CompanyRepository>(
        TractianCompanyRepository.new,
      );
    },
    builder: () => const BusinessAssetsApp(),
  );
}

class BusinessAssetsApp extends StatelessWidget {
  const BusinessAssetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tractian: Business Assets',
      home: CompaniesScreen(),
    );
  }
}
