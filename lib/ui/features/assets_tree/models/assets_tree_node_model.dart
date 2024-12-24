import 'package:equatable/equatable.dart';

import '../../../../core/domain/company_asset/company_asset.dart';
import '../../../../core/domain/company_location/company_location.dart';
import '../../../../core/domain/uid.dart';

sealed class AssetsTreeNodeModel extends Equatable {
  factory AssetsTreeNodeModel.fromCompanyAsset(CompanyAsset asset) =
      AssetNodeModel;

  factory AssetsTreeNodeModel.fromCompanyLocation(CompanyLocation location) =
      LocationNodeModel;

  const AssetsTreeNodeModel({
    required this.id,
    this.parentId,
    this.label = '',
  });

  final Uid id;
  final Uid? parentId;
  final String label;

  @override
  final stringify = true;

  @override
  List<Object?> get props => [id, parentId, label];
}

class AssetNodeModel extends AssetsTreeNodeModel {
  final CompanyAsset asset;

  AssetNodeModel(this.asset)
      : super(
          id: asset.id,
          parentId: asset.parentId ?? asset.locationId,
          label: asset.name,
        );
}

class LocationNodeModel extends AssetsTreeNodeModel {
  final CompanyLocation location;

  LocationNodeModel(this.location)
      : super(
          id: location.id,
          parentId: location.parentId,
          label: location.name,
        );
}
