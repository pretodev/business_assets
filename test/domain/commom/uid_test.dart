import 'package:business_assets/domain/commom/uid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uid', () {
    test('should create a valid Uid from a non-empty string', () {
      const uidString = '12345';
      final uid = Uid.fromString(uidString);
      expect(uid.value, equals(uidString));
    });

    test('should throw ArgumentError when creating Uid from an empty string',
        () {
      expect(() => Uid.fromString(''), throwsArgumentError);
    });

    test('should return true when comparing two Uids with the same value', () {
      const uidString = '12345';
      final uid1 = Uid.fromString(uidString);
      final uid2 = Uid.fromString(uidString);

      expect(uid1, equals(uid2));
    });

    test('should return false when comparing two Uids with different values',
        () {
      final uid1 = Uid.fromString('12345');
      final uid2 = Uid.fromString('67890');

      expect(uid1, isNot(equals(uid2)));
    });

    test('should have string representation equal to the value', () {
      const uidString = '12345';
      final uid = Uid.fromString(uidString);

      expect(uid.toString(), equals(uidString));
    });
  });
}
