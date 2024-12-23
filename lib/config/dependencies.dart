import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/domain/company/company_repository.dart';
import '../core/domain/company_asset/company_asset_repository.dart';
import '../core/domain/company_location/company_location_repository.dart';
import '../infra/repositories/tractian_company_asset_repository.dart';
import '../infra/repositories/tractian_company_location_repository.dart';
import '../infra/repositories/tractian_company_repository.dart';
import '../infra/services/http/tractian_http_client.dart';
import 'tractian/tractian_environment.dart';

List<SingleChildWidget> get providers {
  return [
    Provider.value(
      value: TractianEnvironment(),
    ),
    Provider(
      lazy: true,
      create: (context) => TractanHttpClient(
        environment: context.read(),
      ),
    ),
    Provider<CompanyAssetRepository>(
      lazy: true,
      create: (context) => TractianCompanyAssetRepository(
        httpClient: context.read(),
      ),
    ),
    Provider<CompanyLocationRepository>(
      lazy: true,
      create: (context) => TractianCompanyLocationRepository(
        httpClient: context.read(),
      ),
    ),
    Provider<CompanyRepository>(
      lazy: true,
      create: (context) => TractianCompanyRepository(
        httpClient: context.read(),
      ),
    ),
  ];
}
