import '../../../core/domain/commom/uid.dart';
import '../../../core/domain/company/company.dart';
import '../../../core/domain/company_asset/company_asset.dart';
import '../../../core/domain/company_asset/sensor_types.dart';
import '../../../core/domain/company_asset/statuses.dart';
import '../../../core/domain/company_location/company_location.dart';
import '../utils.dart';

class TractianHttpResponse {
  final int statusCode;
  final dynamic data;

  TractianHttpResponse({
    required this.statusCode,
    required this.data,
  });

  Company _parseCompany(dynamic data) {
    return Company(
      id: Uid.fromString(data['id']),
      name: data['name'],
    );
  }

  List<Company> get companies => data //
      .map<Company>(_parseCompany)
      .toList();

  CompanyLocation _parseCompanyLocation(dynamic data) {
    return CompanyLocation(
      id: Uid.fromString(data['id']),
      name: data['name'],
      parentId: data['parentId'] != null //
          ? Uid.fromString(data['parentId'])
          : null,
    );
  }

  List<CompanyLocation> get companyLocations => data
      .map<CompanyLocation>(_parseCompanyLocation) //
      .toList();

  CompanyAsset _parseCompanyAsset(dynamic data) {
    return CompanyAsset(
      id: Uid.fromString(data['id']),
      name: data['name'],
      locationId: data['locationId'] != null
          ? Uid.fromString(data['locationId'])
          : null,
      parentId: data['parentId'] != null //
          ? Uid.fromString(data['parentId'])
          : null,
      status: data['status'] != null
          ? Statuses.values.maybeName(data['status'])
          : null,
      sensorType: data['sensorType'] != null
          ? SensorTypes.values.maybeName(data['sensorType'])
          : null,
    );
  }

  List<CompanyAsset> get companyAssets => data //
      .map<CompanyAsset>(_parseCompanyAsset)
      .toList();
}
