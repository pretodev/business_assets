import 'package:flutter/foundation.dart';

import '../../../core/domain/company_asset/company_asset_repository.dart';
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

  late final Command1<void, Uid> loadActivities;

  AsyncResult<void> _loadActivities(Uid companyId) async {
    // load activities
    final assetsResult = await _companyAssetRepository //
        .fromCompany(companyId);

    final locationsResult = await _companyLocationRepository //
        .fromCompany(companyId);

    return Result.ok(null);
  }
}
