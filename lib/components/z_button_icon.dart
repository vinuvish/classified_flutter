import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ZButtonIcon extends StatelessWidget {
  final IconData icon;
  final GestureTapCallback onTap;
  final double size;
  final Color color;
  const ZButtonIcon(
      {Key key,
      @required this.icon,
      @required this.onTap,
      this.size,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: IconButton(
            icon: Icon(
              icon,
              size: size ?? 20,
              color: color ?? Theme.of(context).buttonColor,
            ),
            onPressed: onTap));
  }
}
