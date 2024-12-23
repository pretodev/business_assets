import '../../core/domain/commom/uid.dart';
import '../../core/domain/company_location/company_location.dart';
import '../../core/domain/company_location/company_location_repository.dart';
import '../services/http/tractian_http_client.dart';

class TractianCompanyLocationRepository implements CompanyLocationRepository {
  final TractanHttpClient _httpClient;

  TractianCompanyLocationRepository({
    required TractanHttpClient httpClient,
  }) : _httpClient = httpClient;

  @override
  Future<List<CompanyLocation>> fromCompany(Uid companyId) async {
    final response = await _httpClient.get('/companies/$companyId/locations');
    return response.companyLocations;
  }
}
