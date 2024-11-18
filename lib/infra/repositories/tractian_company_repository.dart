import '../../config/tractan/tractan_http_client.dart';
import '../../domain/company/company.dart';
import '../../domain/company/company_repository.dart';
import '../converters/company_converter.dart';
import '../converters/converter.dart';

class TractianCompanyRepository implements CompanyRepository {
  final TractanHttpClient _httpClient;

  TractianCompanyRepository({
    required TractanHttpClient httpClient,
  }) : _httpClient = httpClient;

  @override
  Future<List<Company>> get all async {
    final data = await _httpClient.get('/companies');
    return DataConverter.entities(data, TractianHttpCompanyConverter());
  }
}
