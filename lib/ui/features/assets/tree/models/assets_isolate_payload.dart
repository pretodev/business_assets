import '../../../../../core/domain/company_asset/company_asset.dart';
import '../../../../../core/domain/company_location/company_location.dart';

sealed class AssetsTreeIsolatePayload {
  const AssetsTreeIsolatePayload();
}

class BuildTreeIsolatePayload extends AssetsTreeIsolatePayload {
  const BuildTreeIsolatePayload({
    required this.assets,
    required this.locations,
  });

  final List<CompanyLocation> locations;
  final List<CompanyAsset> assets;

  @override
  String toString() =>
      'BuildTreeIsolateMessage(locations: $locations, assets: $assets)';
}
