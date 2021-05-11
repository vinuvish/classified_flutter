import 'package:classified_flutter/components/search_app_bar.dart';
import 'package:classified_flutter/components/z_product_card.dart';
import 'package:classified_flutter/models/categories.dart';
import 'package:classified_flutter/models/product.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final Categories category;
  SearchPage({Key key, this.category}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Product product;
  ScrollController _scrollController = ScrollController();
  bool _isNextPagination = false;
  bool _isPaginationAvailable = true;
  bool isLoading = false;

  @override
  void initState() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (widget.category != null) {
      // userProvider.fetchStreamFilterdAds(product: category);
    }
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
        appBar: SearchAppBar(),
        body: ListView.builder(
          controller: _scrollController,
          itemCount: userProvider.streamAllAds.length,
          itemBuilder: (context, index) {
            return ZProductCard(
              product: userProvider.streamAllAds[index],
            );
          },
        ));
  }

  _getNextPagination() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (isLoading) {
      userProvider.fetchStreamAllAdsPagination(
          product:
              userProvider.streamAllAds[userProvider.streamAllAds.length - 1]);
      setState(() {
        isLoading = false;
      });
    }
  }
}
