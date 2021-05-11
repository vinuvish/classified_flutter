import 'package:classified_flutter/models_providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

typedef Null OnValueChangeCallBack(String value);

class ZTextFormFieldBottomSheet extends StatefulWidget {
  final bool autovalidate;
  final Function validator;
  final List<String> items;
  final OnValueChangeCallBack onValueChanged;
  final String hint;
  final String initialValue;
  final TextEditingController controller;
  final bool isEnabled;

  ZTextFormFieldBottomSheet({
    Key key,
    @required this.hint,
    @required this.items,
    this.validator,
    this.controller,
    this.isEnabled = true,
    @required this.onValueChanged,
    this.initialValue,
    this.autovalidate,
  }) : super(key: key);

  _ZTextFormFieldBottomSheetState createState() =>
      _ZTextFormFieldBottomSheetState();
}

class _ZTextFormFieldBottomSheetState extends State<ZTextFormFieldBottomSheet> {
  String _selectedVal;
  TextEditingController valueController = TextEditingController();

  @override
  void initState() {
    _selectedVal = widget.initialValue ?? widget.items[0];
    valueController = widget.controller ??
        TextEditingController.fromValue(
            TextEditingValue(text: widget.initialValue ?? ""));
    valueController.addListener(() {
      widget.onValueChanged(valueController.text);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          TextFormField(
            autovalidate: widget.autovalidate ?? false,
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
            maxLines: null,
            controller: valueController,
            enabled: true,
            readOnly: true,
            onSaved: (String value) {},
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.none,
            obscureText: false,
            onTap: () {
              if (widget.isEnabled) {
                _showModalBottomSheet(context: context);
              }
            },
            validator: widget.validator ??
                (String value) {
                  if (value == '') {
                    return 'Please select an item';
                  }
                  return null;
                },
            decoration: InputDecoration(
              isDense: true,
              filled: widget.isEnabled ? true : false,
              fillColor: Theme.of(context).backgroundColor,
              labelText: widget.hint,
              labelStyle: TextStyle(
                  fontSize: 15,
                  color: themeProvider.isLightTheme
                      ? Colors.black26
                      : Colors.white54),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: themeProvider.isLightTheme
                          ? Colors.black26
                          : Colors.white54,
                      width: 1.5),
                  borderRadius: BorderRadius.circular(4)),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).errorColor, width: 1.5),
                  borderRadius: BorderRadius.circular(4)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).errorColor, width: 1.5),
                  borderRadius: BorderRadius.circular(4)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: themeProvider.isLightTheme
                          ? Colors.black12
                          : Colors.white12,
                      width: 1.5),
                  borderRadius: BorderRadius.circular(4)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: themeProvider.isLightTheme
                          ? Colors.black12
                          : Colors.white54,
                      width: 1.5),
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
          Positioned(
            child: GestureDetector(
              onTap: () {
                if (widget.isEnabled) {
                  _showModalBottomSheet(context: context);
                }
              },
              child: Icon(
                Icons.arrow_drop_down,
                color: Colors.white38,
              ),
            ),
            right: 6,
          )
        ],
      ),
    );
  }

  void _showModalBottomSheet({context}) {
    showModalBottomSheet(
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Scrollbar(
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  children: [
                    for (var item in widget.items)
                      Column(
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: widget.items.indexOf(item) == 0
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))
                                  : null,
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Text(
                                  item,
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                              onTap: () {
                                _selectedVal = item;
                                valueController.text = item;
                                widget.onValueChanged(_selectedVal);
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Divider(height: 0, color: Colors.black12)
                        ],
                      ),
                    SizedBox(height: 25)
                  ]),
            ),
          );
        });
  }
}
