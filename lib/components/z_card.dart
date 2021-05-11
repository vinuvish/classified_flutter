import 'package:flutter/material.dart';

class ZCard extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final Color color;
  final GestureTapCallback onTap;
  final Color shadowColor;
  final double elevation;
  final EdgeInsets margin;
  final EdgeInsets padding;
  ZCard(
      {Key key,
      this.child,
      this.borderRadius,
      this.color,
      this.onTap,
      this.shadowColor,
      this.elevation,
      this.margin,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        color: color ?? null,
        elevation: elevation ?? 1,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(5),
        ),
        child: InkWell(
          borderRadius: borderRadius ?? BorderRadius.circular(5),
          onTap: onTap ?? null,
          child: Container(
            padding:
                padding ?? EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: child,
          ),
        ),
      ),
    );
  }
}
