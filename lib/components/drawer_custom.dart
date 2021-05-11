import 'package:classified_flutter/models_providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';

class DrawerCustom extends StatefulWidget {
  @override
  _DrawerCustomState createState() => new _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, model, _) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.all(0.0),
          children: <Widget>[
            GestureDetector(
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/app_drawer_3.jpg'),
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0), BlendMode.srcOver),
                      fit: BoxFit.cover),
                ),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      '${model.authUser.firstName[0]}${model.authUser.lastName[0]}',
                      style: TextStyle(color: Colors.white, fontSize: 24.0),
                    )),
                accountName: Text(
                    '${model.authUser.firstName} ${model.authUser.lastName}',
                    style: TextStyle(color: Colors.black87)),
                accountEmail: Text(
                  model.authUser.email,
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              onTap: () {},
            ),
            _buildTile(
              Icons.library_books,
              'Products',
              () {
                Navigator.of(context).pushNamed('');
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTile(IconData iconData, String title, GestureTapCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 12.0,
              backgroundColor: Colors.white,
              child: Icon(
                iconData,
                color: Color(0xFF6c5ce7),
              ),
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
      splashColor: Colors.purpleAccent,
    );
  }
}
