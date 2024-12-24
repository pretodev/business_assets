import 'package:equatable/equatable.dart';

import '../../../../core/domain/company_asset/company_asset.dart';
import '../../../../core/domain/company_location/company_location.dart';
import '../../assets/widgets/tree/asset_tree_state.dart';

class AssetsTreeLoadMessageModel extends Equatable {
  final List<CompanyAsset> assets;
  final List<CompanyLocation> locations;
  final List<AssetTreeFilter> filters;

  const AssetsTreeLoadMessageModel({
    required this.assets,
    required this.locations,
    required this.filters,
  });

  @override
  final stringify = true;

  @override
  List<Object?> get props => [assets, locations, filters];
}
