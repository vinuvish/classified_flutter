import 'package:flutter/material.dart';

typedef Null SelectValueCallback(String value);
typedef Null SelectIndexCallback(int value);

class WrappedRadios extends StatefulWidget {
  final SelectValueCallback onSelectValue;
  final SelectIndexCallback onSelectIndex;
  final List<String> items;
  final String title;
  final selectedItem;
  const WrappedRadios(
      {Key key,
      this.onSelectValue,
      this.items,
      this.selectedItem,
      this.title,
      this.onSelectIndex})
      : super(key: key);

  @override
  _WrappedRadiosState createState() => _WrappedRadiosState();
}

class _WrappedRadiosState extends State<WrappedRadios> {
  List<WrappedRadiosItem> wrapRadioItems = [];

  @override
  void initState() {
    int index = 0;
    widget.items.forEach((e) {
      bool b = false;
      if (e == widget.selectedItem) {
        b = true;
      }

      WrappedRadiosItem wrappedRadiosItem =
          WrappedRadiosItem(text: e, isSelected: b, index: index);
      wrapRadioItems.add(wrappedRadiosItem);

      index++;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]),
          borderRadius: BorderRadius.circular(3)),
      margin: EdgeInsets.fromLTRB(12, 12, 12, 12),
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: <Widget>[
          if (widget.title != null && widget.title != '')
            Container(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          Wrap(
            alignment: WrapAlignment.center,
            children: wrapRadioItems
                .map((w) => Container(
                      margin: EdgeInsets.all(6),
                      child: InkWell(
                        splashColor: Colors.blue[200],
                        borderRadius: BorderRadius.circular(3),
                        onTap: () {
                          resetState();
                          w.isSelected = !w.isSelected;
                          widget.onSelectValue(w.text);
                          widget.onSelectIndex(w.index);
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                w.isSelected ? Colors.blue[200] : Colors.white,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                                color: w.isSelected
                                    ? Colors.blue[200]
                                    : Colors.grey[300]),
                          ),
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.all(0),
                          child: Text(w.text),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  void resetState() {
    wrapRadioItems.forEach((e) {
      e.isSelected = false;
    });
  }
}

class WrappedRadiosItem {
  final String text;
  final int index;
  bool isSelected;

  WrappedRadiosItem({
    this.isSelected = false,
    this.index = 0,
    @required this.text,
  });
}
