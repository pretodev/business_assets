import 'package:business_assets/domain/commom/uid.dart';
import 'package:business_assets/domain/company_location/company_location.dart';
import 'package:business_assets/infra/converters/company_location_converter.dart';
import 'package:business_assets/infra/converters/converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TractianHttpCompanyLocationConverter', () {
    late TractianHttpCompanyLocationConverter converter;

    setUp(() {
      converter = TractianHttpCompanyLocationConverter();
    });

    test('toData should convert CompanyLocation to JsonData', () {
      final companyLocation = CompanyLocation(
        id: Uid.fromString('456'),
        name: 'Test Location',
      );

      final result = converter.toData(companyLocation);

      expect(result, isA<JsonData>());
      expect(result['id'], '456');
      expect(result['name'], 'Test Location');
    });

    test('toEntity should convert JsonData to CompanyLocation', () {
      final jsonData = {
        'id': '456',
        'name': 'Test Location',
      };

      final result = converter.toEntity(jsonData);

      expect(result, isA<CompanyLocation>());
      expect(result.id.value, '456');
      expect(result.name, 'Test Location');
    });

    test('toEntity should throw an error if id is missing', () {
      final jsonData = {
        'name': 'Test Location',
      };

      expect(() => converter.toEntity(jsonData), throwsA(isA<TypeError>()));
    });

    test('toEntity should throw an error if name is missing', () {
      final jsonData = {
        'id': '456',
      };

      expect(() => converter.toEntity(jsonData), throwsA(isA<TypeError>()));
    });
  });
}
