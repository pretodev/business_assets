import '../../domain/commom/uid.dart';
import '../../domain/company_location/company_location.dart';
import 'converter.dart';

class TractianHttpCompanyLocationConverter
    implements DataConverter<CompanyLocation, JsonData> {
  @override
  JsonData toData(CompanyLocation entity) {
    return {
      'id': entity.id.value,
      'name': entity.name,
      'parentId': entity.parentId?.value,
    };
  }

  @override
  CompanyLocation toEntity(JsonData data) {
    return CompanyLocation(
      id: Uid.fromString(data['id']),
      name: data['name'],
      parentId: data['parentId'] != null //
          ? Uid.fromString(data['parentId'])
          : null,
    );
  }
}
