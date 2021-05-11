import 'package:flutter/material.dart';

class ZButtonText extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onTap;
  final EdgeInsets margin;
  final EdgeInsets padding;

  const ZButtonText({
    Key key,
    this.child,
    this.onTap,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? null,
      child: Container(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        alignment: Alignment.center,
        margin: margin ?? EdgeInsets.symmetric(horizontal: 6),
        child: child,
      ),
    );
  }
}
