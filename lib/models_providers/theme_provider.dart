import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  bool isLightTheme;
  BuildContext context;

  ThemeProvider({this.isLightTheme});

  ThemeData get getThemeData => isLightTheme ? lightTheme : darkTheme;

  getCurrentStatusNavigationBarColor() {
    if (isLightTheme) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: lightTheme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: darkTheme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }
  }

  toggleThemeData() async {
    isLightTheme = !isLightTheme;
    getCurrentStatusNavigationBarColor();
    final settings = await Hive.openBox('settings');
    settings.put('isLightTheme', isLightTheme);
    notifyListeners();
  }
}

/* ----------------------------- NOTE Light Theme --------------------------- */
final lightTheme = ThemeData(
    fontFamily: 'Lato',
    textTheme: TextTheme(),
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    accentColor: Colors.black,
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.black54,
    buttonColor: Color(0xFF70ACF4),
    appBarTheme: AppBarTheme(elevation: 0.0, color: Colors.white),
    focusColor: Colors.blue[200],
    errorColor: Colors.red[200],
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white));

/* ----------------------------- NOTE Dark Theme ---------------------------- */
final darkTheme = ThemeData(
  fontFamily: 'Lato',
  textTheme: TextTheme(),
  primarySwatch: Colors.grey,
  primaryColor: Color(0xFF1E1F28),
  brightness: Brightness.dark,
  backgroundColor: Color(0xFF2A2C36),
  scaffoldBackgroundColor: Color(0xFF1E1F28),
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.white12,
  buttonColor: Color(0xFFEF3651),
  appBarTheme: AppBarTheme(elevation: 0.0, color: Color(0xFF1E1F28)),
);
