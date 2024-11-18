import 'company.dart';

abstract interface class CompanyRepository {
  Future<List<Company>> get all;
}
