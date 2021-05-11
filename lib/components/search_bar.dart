import 'package:flutter/material.dart';

typedef Null ValueChangeCallback(String value);

class SearchBar extends StatefulWidget {
  final ValueChangeCallback onValueChanged;
  final TextEditingController controller;
  final String initialValue;
  final String hint;
  final double width;
  final double height;

  SearchBar({
    this.onValueChanged,
    this.initialValue,
    this.controller,
    this.hint,
    this.width,
    this.height,
    Key key,
  }) : super(key: key);

  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _searchController;
  bool showClose;

  @override
  void initState() {
    _searchController = widget.controller ??
        TextEditingController.fromValue(
            TextEditingValue(text: widget.initialValue ?? ""));
    _searchController.addListener(() {
      widget.onValueChanged(_searchController.text);
      if (_searchController.text.isNotEmpty) showClose = true;
    });

    showClose = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 20,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: <Widget>[
          _buildSearchField(),
          if (showClose)
            InkWell(
              onTap: () {
                if (_searchController == null ||
                    _searchController.text.isEmpty) {
                  showClose = false;
                  FocusScope.of(context).requestFocus(new FocusNode());
                }
                _searchController.clear();
              },
              child: Container(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.clear,
                  color: Colors.black38,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    // return Expanded(
    //   child: Container(
    //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.grey[200]),
    //       color: Colors.grey[200],
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     child: TextField(
    //       controller: _searchController,
    //       decoration: InputDecoration(
    //         isDense: true,
    //         contentPadding: EdgeInsets.symmetric(vertical: 12),
    //         hintText: widget.hint ?? 'Search Products...',
    //         hintStyle: TextStyle(fontSize: 13),
    //         border: InputBorder.none,
    //       ),
    //     ),
    //   ),
    // );

    return Expanded(
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: widget.hint ?? 'Search Items...',
          contentPadding: EdgeInsets.only(top: 0, left: 20),
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black38),
        ),
        style: TextStyle(color: Colors.black, fontSize: 14.5),
      ),
    );
  }
}
