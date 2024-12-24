import '../../core/domain/company/company.dart';
import '../../core/domain/company/company_repository.dart';
import '../../core/domain/result.dart';
import '../services/http/tractian_http_client.dart';

class TractianCompanyRepository implements CompanyRepository {
  final TractanHttpClient _httpClient;

  TractianCompanyRepository({
    required TractanHttpClient httpClient,
  }) : _httpClient = httpClient;

  @override
  AsyncResult<List<Company>> get all async {
    final response = await _httpClient.get('/companies');
    return Result.ok(response.companies);
  }
}
