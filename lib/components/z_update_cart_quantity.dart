import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

typedef Null ValueChangeCallback(num value);

class ZUpdateCartQuantity extends StatefulWidget {
  final EdgeInsets margin;
  final double height;
  final double borderRadius;
  final ValueChangeCallback onValueChanged;
  final num value;
  final bool isAllowedNegativeNumber;

  const ZUpdateCartQuantity({
    Key key,
    this.margin,
    this.height,
    this.borderRadius,
    @required this.value,
    this.onValueChanged,
    this.isAllowedNegativeNumber = true,
  }) : super(key: key);

  @override
  _ZUpdateCartQuantityState createState() => _ZUpdateCartQuantityState();
}

class _ZUpdateCartQuantityState extends State<ZUpdateCartQuantity> {
  TextEditingController controllerQty = TextEditingController();
  double height = 40;
  double borderRadius = 5;

  @override
  void initState() {
    controllerQty.text = widget.value.toInt().toString();
    if (widget.height != null) height = widget.height;
    if (widget.borderRadius != null) height = widget.borderRadius;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey, width: .5),
            ),
            height: height,
            child: Row(
              children: <Widget>[
                Container(
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      bottomLeft: Radius.circular(borderRadius),
                    ),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      bottomLeft: Radius.circular(borderRadius),
                    ),
                    color: Colors.grey[200],
                    child: InkWell(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        bottomLeft: Radius.circular(borderRadius),
                      ),
                      splashColor: Colors.red[100],
                      onTap: () {
                        num newValue = widget.value - 1;
                        if (!widget.isAllowedNegativeNumber) {
                          if (newValue < 0) newValue = 0;
                        }
                        widget.onValueChanged(newValue);
                        controllerQty.text = (newValue).toInt().toString();
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: height,
                        child: Icon(
                          AntDesign.minus,
                          color: Colors.grey,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: height,
                  width: .5,
                  color: Colors.grey,
                ),
                Container(
                  alignment: Alignment.center,
                  height: height,
                  width: 70,
                  child: TextFormField(
                    onChanged: (val) {
                      num newValue = num.tryParse(val) ?? 0;

                      if (!widget.isAllowedNegativeNumber) {
                        if (newValue < 0) newValue = 0;
                      }
                      widget.onValueChanged(newValue);
                    },
                    controller: controllerQty,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      contentPadding: EdgeInsets.only(top: 6),
                      isDense: true,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
                Container(
                  height: height,
                  width: .5,
                  color: Colors.grey,
                ),
                Container(
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(borderRadius),
                      bottomRight: Radius.circular(borderRadius),
                    ),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(borderRadius),
                      bottomRight: Radius.circular(borderRadius),
                    ),
                    color: Colors.grey[200],
                    child: InkWell(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(borderRadius),
                        bottomRight: Radius.circular(borderRadius),
                      ),
                      splashColor: Colors.blue[100],
                      onTap: () {
                        num newValue = widget.value + 1;
                        widget.onValueChanged(newValue);
                        controllerQty.text = (newValue).toInt().toString();
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: height,
                        child: Icon(
                          AntDesign.plus,
                          color: Colors.grey,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
