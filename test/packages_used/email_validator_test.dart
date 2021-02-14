import 'package:email_validator/email_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String tCorrectEmail = 'abc@gmail.com';
  String tWrongEmail = 'abc@gmail';

  group('Email validator tests', () {
    test('Validator should accept right email', () {
      expect(EmailValidator.validate(tCorrectEmail), equals(true));
    });

    test('Validator should reject wrong email', () {
      expect(EmailValidator.validate(tWrongEmail), equals(false));
    });
  });
}
