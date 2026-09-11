
import 'package:email_validator/email_validator.dart';
class FormValidationHelper {
  String? noValidator() {
    return null;
  }

  static String? emptyValidator(String value) {
    if (value.isEmpty) {
      return 'This field is mandatory';
    } else {
      return null;
    }
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is mandatory';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password should have atleast 1 uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password should have atleast 1 lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password should have atleast 1 number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>\-_]').hasMatch(value)) {
      return 'Password should have at least 1 special character';
    }
    if (value.length < 8) {
      return 'Password should be atleast 8 characters';
    }

    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is mandatory';
    }
    if (!EmailValidator.validate(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter phone number';
    }

    final RegExp phoneRegExp = RegExp(r'^[0-9]{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number';
    }

    return null;
  }

  static String? dateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select date';
    }

    final RegExp dateRegExp = RegExp(
      r'^(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])/\d{2}$',
    );

    if (!dateRegExp.hasMatch(value)) {
      return 'Invalid date format (MM/DD/YY)';
    }

    try {
      final List<String> parts = value.split('/');
      final int month = int.parse(parts[0]);
      final int day = int.parse(parts[1]);
      final int year = 2000 + int.parse(parts[2]);

      final DateTime date = DateTime(year, month, day);

      if (date.month != month || date.day != day || date.year != year) {
        return 'Invalid calendar date';
      }
    } catch (e) {
      return 'Invalid date';
    }

    return null;
  }
}
