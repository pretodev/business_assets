import 'package:business_assets/core/domain/company/company.dart';
import 'package:business_assets/core/domain/company_asset/company_asset.dart';
import 'package:business_assets/core/domain/company_asset/sensor_types.dart';
import 'package:business_assets/core/domain/company_asset/statuses.dart';
import 'package:business_assets/core/domain/company_location/company_location.dart';
import 'package:business_assets/core/domain/uid.dart';
import 'package:business_assets/infra/services/http/tractian_http_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tractian Http Response', () {
    test('should convert data to list of Company', () {
      final response = TractianHttpResponse(
        statusCode: 200,
        data: [
          {'id': '1', 'name': 'Company A'},
          {'id': '2', 'name': 'Company B'},
        ],
      );

      final companies = response.companies;

      expect(companies.length, 2);
      expect(companies[0], isA<Company>());
      expect(companies[0].id, Uid.fromString('1'));
      expect(companies[0].name, 'Company A');
      expect(companies[1].id, Uid.fromString('2'));
      expect(companies[1].name, 'Company B');
    });

    test('should convert data to list of CompanyLocation', () {
      final response = TractianHttpResponse(
        statusCode: 200,
        data: [
          {'id': '1', 'name': 'Location A', 'parentId': '10'},
          {'id': '2', 'name': 'Location B'},
        ],
      );

      final locations = response.companyLocations;

      expect(locations.length, 2);
      expect(locations[0], isA<CompanyLocation>());
      expect(locations[0].id, Uid.fromString('1'));
      expect(locations[0].name, 'Location A');
      expect(locations[0].parentId, Uid.fromString('10'));
      expect(locations[1].id, Uid.fromString('2'));
      expect(locations[1].name, 'Location B');
      expect(locations[1].parentId, isNull);
    });

    test('should convert data to list of CompanyAsset', () {
      final response = TractianHttpResponse(
        statusCode: 200,
        data: [
          {
            'id': '1',
            'name': 'Asset A',
            'locationId': '100',
            'parentId': '10',
            'status': 'alert',
            'sensorType': 'energy',
          },
          {
            'id': '2',
            'name': 'Asset B',
            'status': 'operating',
            'sensorType': 'vibration',
          },
        ],
      );

      final assets = response.companyAssets;

      expect(assets.length, 2);
      expect(assets[0], isA<CompanyAsset>());
      expect(assets[0].id, Uid.fromString('1'));
      expect(assets[0].name, 'Asset A');
      expect(assets[0].locationId, Uid.fromString('100'));
      expect(assets[0].parentId, Uid.fromString('10'));
      expect(assets[0].status, Statuses.alert);
      expect(assets[0].sensorType, SensorTypes.energy);
      expect(assets[1].id, Uid.fromString('2'));
      expect(assets[1].name, 'Asset B');
      expect(assets[1].locationId, isNull);
      expect(assets[1].parentId, isNull);
      expect(assets[1].status, Statuses.operating);
      expect(assets[1].sensorType, SensorTypes.vibration);
    });
  });
}
