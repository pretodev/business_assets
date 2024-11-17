import 'package:business_assets/domain/commom/uid.dart';
import 'package:business_assets/domain/company_asset/company_asset.dart';
import 'package:business_assets/infra/converters/company_asset_converter.dart';
import 'package:business_assets/infra/converters/converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TractianHttpCompanyAssetMapper', () {
    late TractianHttpCompanyAssetMapper mapper;

    setUp(() {
      mapper = TractianHttpCompanyAssetMapper();
    });

    test('toData should convert CompanyAsset to JsonData', () {
      final companyAsset = CompanyAsset(
        id: Uid.fromString('123'),
        name: 'Test Asset',
      );

      final result = mapper.toData(companyAsset);

      expect(result, isA<JsonData>());
      expect(result['id'], '123');
      expect(result['name'], 'Test Asset');
    });

    test('toEntity should convert JsonData to CompanyAsset', () {
      final jsonData = {
        'id': '123',
        'name': 'Test Asset',
      };

      final result = mapper.toEntity(jsonData);

      expect(result, isA<CompanyAsset>());
      expect(result.id.value, '123');
      expect(result.name, 'Test Asset');
    });

    test('toEntity should throw an error if id is missing', () {
      final jsonData = {
        'name': 'Test Asset',
      };

      expect(() => mapper.toEntity(jsonData), throwsA(isA<TypeError>()));
    });

    test('toEntity should throw an error if name is missing', () {
      final jsonData = {
        'id': '123',
      };

      expect(() => mapper.toEntity(jsonData), throwsA(isA<TypeError>()));
    });
  });
}
