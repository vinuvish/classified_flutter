import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ZTextBoxOutline extends StatefulWidget {
  final String text;
  final double width;
  ZTextBoxOutline({Key key, this.text, this.width}) : super(key: key);

  @override
  _ZTextBoxOutlineState createState() => _ZTextBoxOutlineState();
}

class _ZTextBoxOutlineState extends State<ZTextBoxOutline> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width ?? MediaQuery.of(context).size.width * 0.80,
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(10.0),
        decoration: myBoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Text(
              widget.text,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Icon(Icons.arrow_drop_down)
          ],
        ));
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 1.0, color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );
  }
}
