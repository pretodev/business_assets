import '../../domain/commom/uid.dart';
import '../../domain/company_asset/company_asset.dart';
import '../../domain/company_asset/sensor_types.dart';
import '../../domain/company_asset/statuses.dart';
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
      'status': entity.status?.name,
      'sensor': entity.sensorType?.name,
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
      status: data['status'] != null
          ? Statuses.values.fromStringOrNull(data['status'])
          : null,
      sensorType: data['sensorType'] != null
          ? SensorTypes.values.fromStringOrNull(data['sensorType'])
          : null,
    );
  }
}
