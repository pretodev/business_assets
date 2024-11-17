import '../../config/tractan/tractan_http_client.dart';
import '../../domain/commom/uid.dart';
import '../../domain/company_location/company_location.dart';
import '../../domain/company_location/company_location_repository.dart';
import '../converters/company_location_converter.dart';
import '../converters/converter.dart';

class TractianCompanyLocationRepository implements CompanyLocationRepository {
  final TractanHttpClient _httpClient;

  TractianCompanyLocationRepository({
    required TractanHttpClient httpClient,
  }) : _httpClient = httpClient;

  @override
  Future<List<CompanyLocation>> fromCompany(Uid companyId) async {
    final data = await _httpClient.get('/companies/$companyId/locations');
    return DataConverter.entities(data, TractianHttpCompanyLocationConverter());
  }
}
