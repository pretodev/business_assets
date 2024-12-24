import '../../../../core/domain/company_asset/company_asset.dart';
import '../../../../core/domain/company_location/company_location.dart';
import '../../../../core/domain/uid.dart';

sealed class TreeNodeModel {
  factory TreeNodeModel.fromCompanyAsset(CompanyAsset asset) = AssetNodeModel;

  factory TreeNodeModel.fromCompanyLocation(CompanyLocation location) =
      LocationNodeModel;

  TreeNodeModel({
    required this.id,
    this.parentId,
    this.label = '',
  });

  final Uid id;
  final Uid? parentId;
  final String label;

  @override
  String toString() => 'AssetTreeNodeModel(id: $id)';
}

class AssetNodeModel extends TreeNodeModel {
  final CompanyAsset asset;

  AssetNodeModel(this.asset)
      : super(
          id: asset.id,
          parentId: asset.parentId ?? asset.locationId,
          label: asset.name,
        );
}

class LocationNodeModel extends TreeNodeModel {
  final CompanyLocation location;

  LocationNodeModel(this.location)
      : super(
          id: location.id,
          parentId: location.parentId,
          label: location.name,
        );
}
