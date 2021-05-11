import 'package:classified_flutter/components/z_product_card.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAdsPage extends StatefulWidget {
  MyAdsPage({Key key}) : super(key: key);

  @override
  _MyAdsPageState createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('My Ads'),
        ),
        body: ListView.builder(
          itemCount: userProvider.streamMyAds.length,
          itemBuilder: (context, index) {
            return ZProductCard(
              product: userProvider.streamMyAds[index],
            );
          },
        ));
  }
}
