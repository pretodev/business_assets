import '../result.dart';
import 'company.dart';

abstract interface class CompanyRepository {
  AsyncResult<List<Company>> get all;
}
