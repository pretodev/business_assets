import '../result.dart';
import '../uid.dart';
import 'company_asset.dart';

abstract interface class CompanyAssetRepository {
  AsyncResult<List<CompanyAsset>> fromCompany(Uid companyId);
}
