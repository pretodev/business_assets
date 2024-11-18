import '../../domain/commom/uid.dart';
import '../../domain/company_asset/company_asset.dart';
import '../../domain/company_location/company_location.dart';

sealed class TreeNodeModel {
  factory TreeNodeModel.fromCompanyAsset(CompanyAsset asset) = AssetNodeModel;

  factory TreeNodeModel.fromCompanyLocation(CompanyLocation location) =
      LocationNodeModel;

  TreeNodeModel({
    required this.id,
    this.parentId,
  });

  final Uid id;
  final Uid? parentId;

  @override
  String toString() => 'AssetTreeNodeModel(id: $id)';
}

class AssetNodeModel extends TreeNodeModel {
  final CompanyAsset asset;

  AssetNodeModel(this.asset)
      : super(
          id: asset.id,
          parentId: asset.parentId ?? asset.locationId,
        );
}

class LocationNodeModel extends TreeNodeModel {
  final CompanyLocation location;

  LocationNodeModel(this.location)
      : super(
          id: location.id,
          parentId: location.parentId,
        );
}
