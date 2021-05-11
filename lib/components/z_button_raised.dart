import 'package:flutter/material.dart';

class ZButtonRaised extends StatelessWidget {
  final GestureTapCallback onTap;
  final EdgeInsets margin;

  final bool isLoading;
  final String text;

  ZButtonRaised({
    @required this.text,
    @required this.onTap,
    this.isLoading,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 48,
      width: double.infinity,
      child: RaisedButton(
        child: Text(
          text.toUpperCase(),
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          onTap();
        },
      ),
    );
  }
}
