import 'package:classified_flutter/components/z_button_icon.dart';
import 'package:classified_flutter/models_providers/auth_provider.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:classified_flutter/pages/app/guest_sign_in_page.dart';
import 'package:classified_flutter/pages/app/settings_page.dart';
import 'package:classified_flutter/pages/user/my_ads_page.dart';
import 'package:classified_flutter/pages/user/my_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return authProvider.isAnonymous
        ? GuestSignInPage()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Account'),
              actions: [
                ZButtonIcon(
                    icon: AntDesign.setting,
                    size: 25,
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return SettingsPage();
                          },
                          fullscreenDialog: true));
                    }),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(16, 16, 12, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("${userProvider.authUser.fullName}"),
                        SizedBox(height: 4),
                        Text("${userProvider.authUser.email}"),
                      ],
                    )),
                Divider(),
                _buildTile(
                  Icons.label_important,
                  'My Ads',
                  () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return MyAdsPage();
                      },
                    ));
                  },
                ),
                Divider(),
                _buildTile(
                  AntDesign.profile,
                  'My Profile',
                  () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return MyProfilePage();
                      },
                    ));
                  },
                ),
                Divider(),
                _buildTile(
                  Icons.credit_card,
                  'My Payments',
                  () {
                    Navigator.of(context).pushNamed('');
                  },
                ),
              ],
            ),
          );
  }

  Widget _buildTile(IconData iconData, String title, GestureTapCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          children: <Widget>[
            Icon(
              iconData,
              color: Theme.of(context).buttonColor,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
      splashColor: Colors.grey,
    );
  }
}
