import '../../domain/commom/uid.dart';
import '../../domain/company/company.dart';
import 'converter.dart';

class TractianHttpCompanyConverter implements DataConverter<Company, JsonData> {
  @override
  JsonData toData(Company entity) {
    return {
      'id': entity.id.value,
      'name': entity.name,
    };
  }

  @override
  Company toEntity(JsonData data) {
    return Company(
      id: Uid.fromString(data['id']),
      name: data['name'],
    );
  }
}
