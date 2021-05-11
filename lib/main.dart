import 'package:bot_toast/bot_toast.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import 'app_utils/get_it.dart';
import 'app_utils/navigator.dart';
import 'app_utils/routes.dart';
import 'models_providers/app_provider.dart';
import 'models_providers/auth_provider.dart';
import 'models_providers/theme_provider.dart';
import 'models_services/notification_service.dart';
import 'pages/app/splash_screen_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final settings = await Hive.openBox('settings');
  settings.put('appVersion', packageInfo.version);
  settings.put('appBuildNumber', packageInfo.buildNumber);
  bool isLightTheme = settings.get('isLightTheme') ?? true;

  runApp(ChangeNotifierProvider(
      create: (_) => ThemeProvider(isLightTheme: isLightTheme),
      child: AppStart()));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class AppStart extends StatelessWidget {
  const AppStart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return MyApp(themeProvider: themeProvider);
  }
}

class MyApp extends StatefulWidget {
  final ThemeProvider themeProvider;
  const MyApp({Key key, this.themeProvider}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  ThemeProvider themeProvider;

  @override
  void initState() {
    NotificationService.init();

    WidgetsBinding.instance.renderView.automaticSystemUiAdjustment = false;
    WidgetsBinding.instance.addObserver(this);

    themeProvider = widget.themeProvider;
    themeProvider.getCurrentStatusNavigationBarColor();

    super.initState();
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    themeProvider.getCurrentStatusNavigationBarColor();
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: BotToastInit(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Classified',
          theme: themeProvider.getThemeData,
          navigatorKey: locator<NavigationService>().navigatorKey,
          navigatorObservers: [BotToastNavigatorObserver()],
          home: SplashScreenPage(),
          routes: Routes.routes,
        ),
      ),
    );
  }
}
