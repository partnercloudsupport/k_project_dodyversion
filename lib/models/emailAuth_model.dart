import 'package:validate/validate.dart';

class EmailAuth {
  String _email;
  String _password;

  String get email => _email;

  set email(str) => this._email = str;

  String get password => _password;

  set password(str) => this._password = str;

  static String validateEmail(str) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    try {
      Validate.isEmail(str);
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
  }

  static String validatePassword(str) {
    if (str.length > 8) {
      try {
        // Validate.isPassword(str);
      } catch (e) {
        return "Password is invalid";
      }
      return null;
    }
    return 'The Password must be at least 8 characters. ';
  }
}
