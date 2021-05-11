import 'package:flutter/material.dart';

typedef Null OnValueChangeCallBack(bool value);

class ZCheckboxListTile extends StatefulWidget {
  final String label;
  final bool value;
  final OnValueChangeCallBack onValueChanged;
  const ZCheckboxListTile({
    Key key,
    @required this.label,
    @required this.value,
    @required this.onValueChanged,
  }) : super(key: key);

  @override
  _ZCheckboxListTileState createState() => _ZCheckboxListTileState();
}

class _ZCheckboxListTileState extends State<ZCheckboxListTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16),
          child: Text('${widget.label}'),
        ),
        Spacer(),
        Checkbox(
            value: widget.value,
            onChanged: (v) {
              widget.onValueChanged(v);
            }),
        SizedBox(
          width: 8,
        )
      ],
    );
  }
}
