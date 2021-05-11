import 'package:flutter/material.dart';

class ZButtonOutline extends StatelessWidget {
  final GestureTapCallback onTap;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final String text;
  final textColor;
  final bool isUpperCaseText = true;
  final double width;

  ZButtonOutline(
      {@required this.text,
      @required this.onTap,
      this.padding,
      this.margin,
      this.textColor,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: OutlineButton(
        borderSide: BorderSide(width: 3.0, color: Colors.grey[400]),
        child: Text(
          isUpperCaseText ? text.toUpperCase() : text,
          style: TextStyle(
              color: textColor ?? Theme.of(context).textTheme.button.color,
              fontSize: 12),
        ),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          onTap();
        },
      ),
    );
  }
}
