import 'package:auto_injector/auto_injector.dart';

import '../../core/domain/company/company_repository.dart';
import '../../core/domain/company_asset/company_asset_repository.dart';
import '../../core/domain/company_location/company_location_repository.dart';
import '../../infra/repositories/tractian_company_asset_repository.dart';
import '../../infra/repositories/tractian_company_location_repository.dart';
import '../../infra/repositories/tractian_company_repository.dart';
import '../../infra/services/http/tractian_http_client.dart';
import '../tractian/tractian_environment.dart';

class ServiceLocator {
  ServiceLocator() {
    _injector.addInstance(TractianEnvironment());
    _injector.addLazySingleton<TractanHttpClient>(
      TractanHttpClient.new,
    );
    _injector.addLazySingleton<CompanyAssetRepository>(
      TractianCompanyAssetRepository.new,
    );
    _injector.addLazySingleton<CompanyLocationRepository>(
      TractianCompanyLocationRepository.new,
    );
    _injector.addLazySingleton<CompanyRepository>(
      TractianCompanyRepository.new,
    );
    _injector.commit();
  }

  final _injector = AutoInjector();

  T get<T>() => _injector.get<T>();
}
