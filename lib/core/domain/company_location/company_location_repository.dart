import '../result.dart';
import '../uid.dart';
import 'company_location.dart';

abstract class CompanyLocationRepository {
  AsyncResult<List<CompanyLocation>> fromCompany(Uid companyId);
}
