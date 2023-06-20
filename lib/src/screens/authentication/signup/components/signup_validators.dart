import 'package:form_field_validator/form_field_validator.dart';

final validateUsername = MultiValidator([
  LengthRangeValidator(min: 5, max: 15, errorText: 'Username must be between 5 and 15 characters long.'),
  PatternValidator(r'^[a-zA-Z0-9]+$', errorText: 'Username can only contain letters and numbers.'),
]);

final validateEmail = MultiValidator([
  RequiredValidator(errorText: 'Email is required.'),
  EmailValidator(errorText: 'Invalid email address.'),
]);

final validatePassword = MultiValidator([
  MinLengthValidator(8, errorText: 'Password must be at least 8 characters long.'),
  PatternValidator(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
    errorText:
        'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.',
  ),
]);

final validateRePassword = MatchValidator(errorText: 'Passwords do not match. Please make sure the passwords match.');