import '../../domain/commom/uid.dart';
import '../../domain/company_asset/company_asset.dart';
import 'converter.dart';

class TractianHttpCompanyAssetMapper
    implements DataConverter<CompanyAsset, JsonData> {
  @override
  JsonData toData(CompanyAsset entity) {
    return {
      'id': entity.id.value,
      'name': entity.name,
      'location_id': entity.locationId?.value,
      'parent_id': entity.parentId?.value,
    };
  }

  @override
  CompanyAsset toEntity(JsonData data) {
    return CompanyAsset(
      id: Uid.fromString(data['id']),
      name: data['name'],
      locationId: data['location_id'] != null
          ? Uid.fromString(data['location_id'])
          : null,
      parentId: data['parent_id'] != null //
          ? Uid.fromString(data['parent_id'])
          : null,
    );
  }
}
