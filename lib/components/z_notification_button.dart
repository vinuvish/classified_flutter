import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ZNotificationButton extends StatefulWidget {
  final bool isNotificationsEnabled;
  final GestureTapCallback onTap;
  ZNotificationButton(
      {Key key, @required this.isNotificationsEnabled, @required this.onTap})
      : super(key: key);

  @override
  _ZNotificationButtonState createState() => _ZNotificationButtonState();
}

class _ZNotificationButtonState extends State<ZNotificationButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
          child: Icon(widget.isNotificationsEnabled
              ? Icons.notifications
              : Icons.notifications_off),
          onTap: widget.onTap ?? null),
    );
  }
}
