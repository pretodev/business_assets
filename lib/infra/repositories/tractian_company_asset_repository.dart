import '../../config/tractan/tractan_http_client.dart';
import '../../domain/commom/uid.dart';
import '../../domain/company_asset/company_asset.dart';
import '../../domain/company_asset/company_asset_repository.dart';
import '../converters/company_asset_converter.dart';
import '../converters/converter.dart';

class TractianCompanyAssetRepository implements CompanyAssetRepository {
  final TractanHttpClient _httpClient;

  TractianCompanyAssetRepository({
    required TractanHttpClient httpClient,
  }) : _httpClient = httpClient;

  @override
  Future<List<CompanyAsset>> fromCompany(Uid companyId) async {
    final data = await _httpClient.get('/companies/$companyId/assets');
    return DataConverter.entities(data, TractianHttpCompanyAssetMapper());
  }
}
