import 'package:classified_flutter/models_providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

typedef Null ValueChangeCallback(DateTime value);
typedef Null OnSavedChangeCallback(DateTime value);

class ZTextFormFieldCalendar extends StatefulWidget {
  final bool autovalidate;
  final Color containerColor;
  final DateTime initialValue;
  final Function validator;
  final GestureTapCallback onTap;
  final String hint;
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValueChangeCallback onSaved;
  final ValueChangeCallback onValueChanged;
  final bool isEnabled;
  final bool isNumberCurrencyInput;
  final bool obscureText;
  final bool readyOnly;
  final int maxLength;
  final int maxLines;

  ZTextFormFieldCalendar({
    @required this.hint,
    Key key,
    this.autovalidate,
    this.containerColor,
    this.controller,
    this.initialValue,
    this.isEnabled = true,
    this.isNumberCurrencyInput = false,
    this.keyboardType,
    this.maxLength,
    this.maxLines,
    this.obscureText,
    this.onSaved,
    this.onTap,
    this.onValueChanged,
    this.readyOnly = false,
    this.textCapitalization,
    this.validator,
  }) : super(key: key);

  @override
  _ZTextFormFieldCalendarState createState() => _ZTextFormFieldCalendarState();
}

class _ZTextFormFieldCalendarState extends State<ZTextFormFieldCalendar> {
  TextEditingController valueController;
  DateTime _date = DateTime.now();
  DateTime _firstDate = DateTime(DateTime.now().day);
  DateTime _lastDate = DateTime(DateTime.now().year + 2);

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) _date = widget.initialValue;
    valueController = widget.controller ??
        TextEditingController.fromValue(
            TextEditingValue(text: dateFormatStr(widget.initialValue)));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        children: <Widget>[
          TextFormField(
            autovalidate: widget.autovalidate ?? false,
            maxLength: widget.maxLength ?? null,
            maxLines: widget.maxLines ?? 1,
            enabled: widget.isEnabled ?? true,
            readOnly: true,
            onTap: () async {
              updateDateValues();
            },
            onSaved: (String value) {
              widget.onSaved(_date);
            },
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
            keyboardType: widget.keyboardType ?? TextInputType.text,
            textCapitalization:
                widget.textCapitalization ?? TextCapitalization.none,
            obscureText: widget.obscureText ?? false,
            controller: valueController,
            validator: widget.validator ??
                (String value) {
                  if (value.isEmpty) {
                    return 'This field is required';
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
            right: 10,
            top: 11,
            child: GestureDetector(
              child: Icon(
                AntDesign.calendar,
                color: Colors.white38,
              ),
              onTap: () async {
                updateDateValues();
              },
            ),
          )
        ],
      ),
    );
  }

  void updateDateValues() async {
    var result = await showDatePicker(
        useRootNavigator: true,
        context: context,
        initialDate: _date,
        firstDate: _firstDate,
        lastDate: _lastDate);
    FocusScope.of(context).requestFocus(new FocusNode());
    if (result != null) {
      _date = result;
      valueController.text = dateFormatStr(_date);
      setState(() {});
    }
  }

  dateFormatStr(DateTime dateTime) {
    if (dateTime == null) return '';
    return DateFormat("dd-MM-yyyy").format(dateTime);
  }
}
