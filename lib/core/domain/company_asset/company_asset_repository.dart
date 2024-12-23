import '../commom/uid.dart';
import 'company_asset.dart';

abstract interface class CompanyAssetRepository {
  Future<List<CompanyAsset>> fromCompany(Uid companyId);
}
