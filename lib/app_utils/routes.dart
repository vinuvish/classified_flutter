import 'package:classified_flutter/pages/app/app_home_page.dart';
import 'package:classified_flutter/pages/app/email_unverified_page.dart';
import 'package:flutter/cupertino.dart';
import '../pages/app/onboarding_page.dart';
import '../pages/app/reset_password.dart';
import '../pages/app/sign_in_page.dart';
import '../pages/app/sign_up_page.dart';
import '../pages/app/splash_screen_page.dart';
import '../pages/app/update_app_page.dart';

class Constants {
  static const String ROUTE_SPLASH_SCREEN_PAGE = '/splash_screen_page';
  static const String ROUTE_ONBOARDING_PAGE = '/onboarding_page';
  static const String ROUTE_UPDATE_APP_PAGE = '/update_app_page';
  static const String ROUTE_SIGN_IN_PAGE = '/sign_in';
  static const String ROUTE_SIGN_UP_PAGE = '/sign_up';
  static const String ROUTE_RESET_PASSWORD = '/reset_password';
  static const String ROUTE_HOME_PAGE = '/home_page';
  static const String ROUTE_USER_EMAIL_UN_VERIFIED_PAGE =
      '/user_email_un_verified_page';
  static const String ROUTE_USER_EMAIL_VERIFIED_PAGE =
      '/user_email_verified_page';
}

class Routes {
  static final routes = <String, WidgetBuilder>{
    Constants.ROUTE_ONBOARDING_PAGE: (context) => OnboardingPage(),
    Constants.ROUTE_HOME_PAGE: (context) => AppHomePage(),
    Constants.ROUTE_UPDATE_APP_PAGE: (context) => UpdateAppPage(),
    Constants.ROUTE_SIGN_IN_PAGE: (context) => SignInPage(),
    Constants.ROUTE_SIGN_UP_PAGE: (context) => SignUpPage(),
    Constants.ROUTE_RESET_PASSWORD: (context) => ResetPasswordPage(),
    Constants.ROUTE_SPLASH_SCREEN_PAGE: (context) => SplashScreenPage(),
    Constants.ROUTE_USER_EMAIL_UN_VERIFIED_PAGE: (context) =>
        EmailUnverifiedPage()
  };
}
