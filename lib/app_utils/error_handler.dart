class ErrorHandler {
  static const String COMMON_ERROR = 'There is an error!!!';
  static const String UNDEFIN_ERROR = 'An undefined Error happened.';
  static const String INVALID_EMAIL = "Invalid Email Address!!!";
  static const String INVALID_PASSWORD = "Invalid Password!!!";
  static const String VALID_EMAIL_TYPE = "Please Enter a valid Email Address";
  static const String VERIFY_EMAIL = "Verify The Email Address!!!";

  static const String INVALID_EMAIL_OR_PASSWORD = "Invalid Email or Password";
  static const String TO_MANY_REQUEST = "Too many requests. Try again later.";
  static const String INVALID_CODE = "Invalid Code!!!";
  static const String OPERATION_NOT_ALLOWED =
      "Signing in with Email and Password is not enabled.";

  static const String EMAIL_EMPTY = "Email can't be Empty";
  static const String PASSWORD_EMPTY = "Password can't be Empty";
  static const String USERNAME_EMPTY = "UserName can't be Empty";
  static const String USERNAME_ALREADY_CREATED = "Email Already in use";
  static const String MOBILE_EMPTY = "Mobile can't be Empty";
  static const String ERROR_USER_DISABLED =
      "User with this email has been disabled.";

//--------------------Product Validation----------------------------------
  static const String MENU_NAME_EMPTY = "Manu Name can't be Empty";
  static const String MENU_TIME_ERROR = "Invalid time ";

  static const String USERNAME_LENGTH_VALIDATE =
      "User Name should be more than 3 letters";
  static const String PASSWORD_LENGTH_VALIDATE =
      "Password should be more than 6 letters";
  static const String MOBILE_LENGTH_VALIDATE =
      "Mobile number should be 10 digits";
//--------------------ERRORS----------------------------------

  static const String ERROR_PASSWORD = "ERROR_WRONG_PASSWORD";
  static const String ERROR_USER = "ERROR_USER_NOT_FOUND";
  static const String ERROR_USER_ALREADY_CREATED = "ERROR_EMAIL_ALREADY_IN_USE";
  static const String ERROR_USER_NOT_CREATED = "sign_in_failed";

  static String authErrorHandelar(errorCode) {
    String errorMessage;
    print(errorMessage);

    switch (errorCode.code) {
      case "ERROR_INVALID_EMAIL":
        errorMessage = ErrorHandler.INVALID_EMAIL_OR_PASSWORD;
        break;
      case "ERROR_WRONG_PASSWORD":
        errorMessage = ErrorHandler.INVALID_EMAIL_OR_PASSWORD;
        break;
      case "ERROR_USER_NOT_FOUND":
        errorMessage = ErrorHandler.INVALID_EMAIL_OR_PASSWORD;
        break;
      case "ERROR_USER_DISABLED":
        errorMessage = ErrorHandler.ERROR_USER_DISABLED;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        errorMessage = ErrorHandler.TO_MANY_REQUEST;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = ErrorHandler.OPERATION_NOT_ALLOWED;
        break;
      default:
        errorMessage = ErrorHandler.UNDEFIN_ERROR;
    }

    return errorMessage;
  }
}
