import 'package:flutter/foundation.dart';

import '../../../core/domain/company_asset/company_asset.dart';
import '../../../core/domain/company_asset/company_asset_repository.dart';
import '../../../core/domain/company_location/company_location.dart';
import '../../../core/domain/company_location/company_location_repository.dart';
import '../../../core/domain/result.dart';
import '../../../core/domain/uid.dart';
import '../command.dart';

class AssetsViewModel extends ChangeNotifier {
  final CompanyAssetRepository _companyAssetRepository;
  final CompanyLocationRepository _companyLocationRepository;

  AssetsViewModel({
    required CompanyAssetRepository companyAssetRepository,
    required CompanyLocationRepository companyLocationRepository,
  })  : _companyAssetRepository = companyAssetRepository,
        _companyLocationRepository = companyLocationRepository {
    loadActivities = Command1(_loadActivities);
  }

  List<CompanyAsset> assets = [];
  List<CompanyLocation> locations = [];

  late final Command1<void, Uid> loadActivities;

  AsyncResult<void> _loadActivities(Uid companyId) async {
    final assetsResult = await _companyAssetRepository //
        .fromCompany(companyId);
    switch (assetsResult) {
      case Ok():
        assets = assetsResult.value;
        break;
      case Error():
        return assetsResult;
    }

    final locationsResult = await _companyLocationRepository //
        .fromCompany(companyId);
    switch (locationsResult) {
      case Ok():
        locations = locationsResult.value;
        break;
      case Error():
        return locationsResult;
    }

    notifyListeners();
    return Result.ok(null);
  }
}
