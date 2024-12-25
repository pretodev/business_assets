import '../../core/domain/company_location/company_location.dart';
import '../../core/domain/company_location/company_location_repository.dart';
import '../../core/domain/result.dart';
import '../../core/domain/uid.dart';
import '../services/http/tractian_http_client.dart';

class TractianCompanyLocationRepository implements CompanyLocationRepository {
  final TractanHttpClient _httpClient;

  TractianCompanyLocationRepository({
    required TractanHttpClient httpClient,
  }) : _httpClient = httpClient;

  @override
  AsyncResult<List<CompanyLocation>> fromCompany(Uid companyId) async {
    final response = await _httpClient.get('/companies/$companyId/locations');
    return Result.ok(response.companyLocations);
  }
}
