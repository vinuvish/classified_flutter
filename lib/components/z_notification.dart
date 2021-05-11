import 'package:badges/badges.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:classified_flutter/pages/app/notification_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:provider/provider.dart';

class ZNotification extends StatefulWidget {
  @override
  _ZNotificationState createState() => _ZNotificationState();
}

class _ZNotificationState extends State<ZNotification> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Opacity(
      opacity: 0.5,
      child: InkWell(
        child: Badge(
          badgeColor: Theme.of(context).buttonColor,
          position: BadgePosition.topRight(top: 2, right: 10),
          badgeContent: Text('0'),
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Icon(Icons.notifications)),
        ),
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return NotificationPage();
              },
              fullscreenDialog: true));
        },
      ),
    );
  }
}
