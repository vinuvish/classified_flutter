import 'package:classified_flutter/components/z_button_raised.dart';
import 'package:classified_flutter/models_providers/auth_provider.dart';
import 'package:classified_flutter/models_providers/theme_provider.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 4, 4),
            child: Row(
              children: <Widget>[
                Text(
                  'Switch theme',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Spacer(),
                Switch(
                  activeColor: Theme.of(context).buttonColor,
                  value: !themeProvider.isLightTheme,
                  onChanged: (val) {
                    themeProvider.toggleThemeData();
                    setState(() {});
                  },
                )
              ],
            ),
          ),
          ZButtonRaised(
              text: 'Sign Out',
              onTap: () async {
                bool res = await authProvider.signOut();
                if (res) {
                  Navigator.of(context).pop();
                  userProvider.clearStreams();
                  userProvider.clearAllStates();
                }
              })
        ],
      ),
    );
  }
}
