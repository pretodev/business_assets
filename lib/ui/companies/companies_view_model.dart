import 'package:flutter/foundation.dart';

import '../../core/domain/company/company.dart';
import '../../core/domain/company/company_repository.dart';
import '../../core/domain/result.dart';
import '../command.dart';

class CompaniesViewModel extends ChangeNotifier {
  final CompanyRepository _companyRepository;

  CompaniesViewModel({
    required CompanyRepository companyRepository,
  }) : _companyRepository = companyRepository {
    loadCompanies = Command0(_loadCompanies);
  }

  List<Company> _companies = [];

  List<Company> get companies => _companies;

  late final Command0 loadCompanies;

  Future<Result<void>> _loadCompanies() async {
    // load companies
    final result = await _companyRepository.all;
    switch (result) {
      case Ok():
        _companies = result.value;
        notifyListeners();
      case Error():
        print('ERROR: ${result.error}');
    }

    return result;
  }
}
