import 'package:classified_flutter/components/search_bar.dart';
import 'package:classified_flutter/components/z_product_card.dart';
import 'package:classified_flutter/models/categories.dart';
import 'package:classified_flutter/models/subCategories.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatefulWidget {
  final Categories category;
  final SubCategories subCategory;
  FilterPage({Key key, this.category, this.subCategory}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  ScrollController _scrollController = ScrollController();
  bool _isNextPagination = false;
  bool _isPaginationAvailable = true;
  bool isLoading = false;

  @override
  void initState() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    userProvider.fetchFilterdAds(
        category: widget.category, subCategory: widget.subCategory);

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentScroll <= delta) {
        setState(() {
          isLoading = true;
        });
        _getNextPagination();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
        appBar: AppBar(
          actions: [
            SearchBar(
              width: 300,
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.filter_list),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: ListView(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                  for (var prod in userProvider.streamFilterdAds)
                    ZProductCard(
                      product: prod,
                    )
                ]))
          ],
        ));
  }

  _getNextPagination() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (isLoading) {
      userProvider.fetchFilterdPaginationdAds(
          product: userProvider
              .streamFilterdAds[userProvider.streamFilterdAds.length - 1],
          category: widget.category);

      setState(() {
        isLoading = false;
      });
    }
  }
}
