import 'package:classified_flutter/pages/app/profile_page.dart';
import 'package:classified_flutter/pages/app/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../components/z_buttom_navbar.dart';
import '../../models_providers/app_provider.dart';
import '../../models_providers/theme_provider.dart';
import 'chat_page.dart';
import 'home_page.dart';
import 'post_or_edit_ad.dart';

class AppHomePage extends StatefulWidget {
  _AppHomePageState createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: userPages.elementAt(appProvider.selectedPageIndex),
      bottomNavigationBar: ZBottomNavbar(
        backgroundColor:
            themeProvider.isLightTheme ? Color(0xFFF9F9F9) : Color(0xFF1E1F28),
        selectedColor:
            themeProvider.isLightTheme ? Colors.black87 : Colors.white,
        deselectedColor:
            themeProvider.isLightTheme ? Colors.black54 : Colors.white54,
        selectedIndex: appProvider.selectedPageIndex,
        items: [
          ...userBottomNavbarCustomItem,
        ],
        onIndexChange: (value) {
          appProvider.setSelectedPageIndex(index: value);
        },
      ),
    );
  }

/* ----------------------------- NOTE UserPages ----------------------------- */
  List<Widget> userPages = [
    HomePage(),
    SearchPage(),
    PostOrEditAd(),
    ChatPage(),
    ProfilePage()
  ];

  List<ZBottomNavbarItem> userBottomNavbarCustomItem = [
    ZBottomNavbarItem(text: 'Home', icon: AntDesign.home),
    ZBottomNavbarItem(text: 'Search', icon: AntDesign.search1),
    ZBottomNavbarItem(text: 'AD', icon: AntDesign.plus),
    ZBottomNavbarItem(text: 'Chat', icon: AntDesign.message1),
    ZBottomNavbarItem(text: 'Profile', icon: AntDesign.user),
  ];
}
