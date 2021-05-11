import 'package:flutter/material.dart';

typedef Null ValueChangeCallback(String value);

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget title;
  final double elevation;
  final Size preferredSize;
  final ValueChangeCallback onValueChanged;
  final PreferredSizeWidget bottom;

  SearchAppBar({
    Key key,
    this.title,
    this.elevation,
    this.bottom,
    this.onValueChanged,
  })  : preferredSize = Size.fromHeight(
            kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
        super(key: key);

  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  TextEditingController _searchQuery;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQuery.clear();
      updateSearchQuery('');
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      widget.onValueChanged(newQuery);
    });
  }

  Widget _buildTitle(BuildContext context) {
    return widget.title;
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.black),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: widget.elevation ?? 4.0,
      automaticallyImplyLeading: false,
      // leading: _isSearching
      //     ? IconButton(
      //         icon: BackButton(),
      //         onPressed: () {
      //           _clearSearchQuery();
      //           Navigator.pop(context);
      //         },
      //       )
      //     : null,
      title: _isSearching ? _buildSearchField() : _buildTitle(context),
      actions: _buildActions(),
    );
  }
}
