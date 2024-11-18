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
      'locationId': entity.locationId?.value,
      'parentId': entity.parentId?.value,
    };
  }

  @override
  CompanyAsset toEntity(JsonData data) {
    return CompanyAsset(
      id: Uid.fromString(data['id']),
      name: data['name'],
      locationId: data['locationId'] != null
          ? Uid.fromString(data['locationId'])
          : null,
      parentId: data['parentId'] != null //
          ? Uid.fromString(data['parentId'])
          : null,
    );
  }
}
