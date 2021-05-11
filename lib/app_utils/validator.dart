import 'error_handler.dart';

class EmailValidator {
  static String validate(String value) {
    value = value.toLowerCase();
    if (value.isEmpty) {
      return ErrorHandler.EMAIL_EMPTY;
    }
    if (value.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return ErrorHandler.VALID_EMAIL_TYPE;
    }
    return null;
  }
}

class UserNameValidator {
  static String validate(String value) {
    value = value.toLowerCase();
    if (value.isEmpty) {
      return ErrorHandler.USERNAME_EMPTY;
    }
    if (value.length < 3) {
      return ErrorHandler.USERNAME_LENGTH_VALIDATE;
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    value = value.toLowerCase();
    if (value.isEmpty) {
      return ErrorHandler.PASSWORD_EMPTY;
    }
    if (value.length < 5) {
      return ErrorHandler.PASSWORD_LENGTH_VALIDATE;
    }
    return null;
  }
}

class MobileNumberValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return ErrorHandler.MOBILE_EMPTY;
    }
    if (value.length > 10) {
      return ErrorHandler.MOBILE_LENGTH_VALIDATE;
    }
    if (value.length < 10) {
      return ErrorHandler.MOBILE_LENGTH_VALIDATE;
    }
    return null;
  }
}

class AdTitleValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return 'This field is required';
    }
    if (value.length > 15) {
      return 'Title should short no more than 15 letter';
    }

    return null;
  }
}
