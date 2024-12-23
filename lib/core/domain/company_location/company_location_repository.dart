import '../uid.dart';
import 'company_location.dart';

abstract class CompanyLocationRepository {
  Future<List<CompanyLocation>> fromCompany(Uid companyId);
}
