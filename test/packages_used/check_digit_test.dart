import 'package:checkdigit/checkdigit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String tCorrectAadhar = '630096958682';
  String tWrongAadhar = '630096958685';

  group('Aadhar number validator tests', () {
    test('Validator should accept right aadhar number', () {
      expect(verhoeff.validate(tCorrectAadhar), equals(true));
    });

    test('Validator should reject wrong aadhar number', () {
      expect(verhoeff.validate(tWrongAadhar), equals(false));
    });
  });
}
