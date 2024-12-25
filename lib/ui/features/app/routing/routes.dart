import '../../../../core/domain/uid.dart';

abstract final class Routes {
  // resources
  static const _companies = 'companies';

  // routes
  static const companies = '/$_companies';
  static String companyAssets(Uid id) => '/$_companies/${id.value}';
}
