import '../../core/domain/company_asset/company_asset.dart';
import '../../core/domain/company_asset/company_asset_repository.dart';
import '../../core/domain/result.dart';
import '../../core/domain/uid.dart';
import '../services/http/tractian_http_client.dart';

class TractianCompanyAssetRepository implements CompanyAssetRepository {
  final TractanHttpClient _httpClient;

  TractianCompanyAssetRepository({
    required TractanHttpClient httpClient,
  }) : _httpClient = httpClient;

  @override
  AsyncResult<List<CompanyAsset>> fromCompany(Uid companyId) async {
    final response = await _httpClient.get('/companies/$companyId/assets');
    return Result.ok(response.companyAssets);
  }
}
