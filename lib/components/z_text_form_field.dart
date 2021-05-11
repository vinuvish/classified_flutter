import 'package:classified_flutter/models_providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum CurrencyNumberFormat { number, currency }
enum WhitelistingTextInput { positive, positiveNegative }

typedef Null ValueChangeCallback(String value);
typedef Null OnSavedChangeCallback(String value);

class ZTextFormField extends StatefulWidget {
  final ValueChangeCallback onValueChanged;
  final String hint;
  final TextEditingController controller;
  final Function validator;
  final Color containerColor;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final ValueChangeCallback onSaved;
  final bool isEnabled;
  final String initialValue;
  final bool obscureText;
  final int maxLines;
  final int maxLength;
  final bool isNumberCurrencyInput;
  final CurrencyNumberFormat currencyNumberFormatType;
  final WhitelistingTextInput whitelistingTextType;
  final bool readyOnly;
  final GestureTapCallback onTap;
  final Widget suffix;
  final bool autovalidate;

  ZTextFormField({
    Key key,
    @required this.hint,
    this.controller,
    this.onValueChanged,
    this.isEnabled = true,
    this.onSaved,
    this.keyboardType,
    this.textCapitalization,
    this.validator,
    this.containerColor,
    this.initialValue,
    this.obscureText,
    this.maxLength,
    this.maxLines,
    this.isNumberCurrencyInput = false,
    this.currencyNumberFormatType = CurrencyNumberFormat.number,
    this.whitelistingTextType = WhitelistingTextInput.positiveNegative,
    this.readyOnly = false,
    this.onTap,
    this.suffix,
    this.autovalidate,
  }) : super(key: key);

  @override
  _ZTextFormFieldState createState() => _ZTextFormFieldState();
}

class _ZTextFormFieldState extends State<ZTextFormField> {
  TextEditingController valueController;

  @override
  void initState() {
    super.initState();
    valueController = widget.controller ??
        TextEditingController.fromValue(
            TextEditingValue(text: widget.initialValue ?? ""));
    valueController.addListener(() {
      if (widget.onValueChanged != null) {
        widget.onValueChanged(valueController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextFormField(
        autovalidate: widget.autovalidate ?? false,
        inputFormatters: widget.isNumberCurrencyInput
            ? [
                if (widget.whitelistingTextType ==
                    WhitelistingTextInput.positive)
                  WhitelistingTextInputFormatter(RegExp("[0-9]")),
                if (widget.whitelistingTextType ==
                    WhitelistingTextInput.positiveNegative)
                  WhitelistingTextInputFormatter(RegExp("[0-9-]")),
                if (widget.currencyNumberFormatType ==
                    CurrencyNumberFormat.number)
                  NumberInputFormatter(),
                if (widget.currencyNumberFormatType ==
                    CurrencyNumberFormat.currency)
                  CurrencyInputFormatter()
              ]
            : null,
        maxLength: widget.maxLength ?? null,
        maxLines: widget.maxLines ?? 1,
        enabled: widget.isEnabled ?? true,
        readOnly: widget.readyOnly,
        onTap: widget.onTap ?? null,
        onSaved: (String value) {
          if (widget.isNumberCurrencyInput) {
            value = value.replaceAll('\$', '');
            value = value.replaceAll(',', '');
          }
          if (widget.readyOnly == false) {
            widget.onSaved(value);
          }
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
          prefix:
              widget.currencyNumberFormatType == CurrencyNumberFormat.currency
                  ? Text('\$')
                  : null,
          suffix: widget.suffix ?? null,
          filled: widget.isEnabled ? true : false,
          fillColor: Theme.of(context).backgroundColor,
          labelText: widget.hint,
          labelStyle: TextStyle(
              fontSize: 15,
              color:
                  themeProvider.isLightTheme ? Colors.black26 : Colors.white54),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: themeProvider.isLightTheme
                      ? Colors.black26
                      : Colors.white54,
                  width: 1.5),
              borderRadius: BorderRadius.circular(4)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).errorColor, width: 1.5),
              borderRadius: BorderRadius.circular(4)),
          errorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).errorColor, width: 1.5),
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
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.contains('-')) {
      String textValue = newValue.text;
      if (textValue.endsWith('-') && textValue.startsWith('-')) {
        textValue = textValue.replaceAll('-', '');
        newValue = newValue.copyWith(text: textValue);
      } else {
        textValue = textValue.replaceAll('-', '');
        textValue = '-' + textValue;
        newValue = newValue.copyWith(text: textValue);
      }
    }

    double value = double.parse(newValue.text);

    final formatter = new NumberFormat("#,##0.00", "en_US");

    String newText = formatter.format(value / 100);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}

class NumberInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.contains('-')) {
      String textValue = newValue.text;
      if (textValue.endsWith('-') && textValue.startsWith('-')) {
        textValue = textValue.replaceAll('-', '');
        newValue = newValue.copyWith(text: textValue);
      } else {
        textValue = textValue.replaceAll('-', '');
        textValue = '-' + textValue;
        newValue = newValue.copyWith(text: textValue);
      }
    }

    double value = double.tryParse(newValue.text) ?? 0.0;

    final formatter = new NumberFormat("#,##0");

    String newText = formatter.format(value);
    if (newText == '0') {
      newText = '';
    }

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}
