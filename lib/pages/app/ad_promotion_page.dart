import 'package:classified_flutter/components/z_button_raised.dart';
import 'package:classified_flutter/models/product.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:classified_flutter/models_providers/app_provider.dart';

class AdPromotionpage extends StatefulWidget {
  final Product product;
  final List<Asset> imageAssets;
  AdPromotionpage({Key key, this.product, this.imageAssets}) : super(key: key);

  @override
  _AdPromotionpageState createState() => _AdPromotionpageState();
}

class _AdPromotionpageState extends State<AdPromotionpage> {
  bool _isFeatured = false;
  bool _isUrgent = false;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Ad Promotions'),
      ),
      body: Container(
          child: Column(
        children: [
          Divider(),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: CheckboxListTile(
              value: _isFeatured,
              onChanged: (bool val) {
                _isFeatured = val;
                widget.product.isfeatured = _isFeatured;
                setState(() {});
              },
              title: Text(
                "Feature Ad",
              ),
              subtitle: Text(
                  'Get 10 time or more views by displaying your ad at the top'),
              isThreeLine: true,
              secondary: Container(
                child: Icon(
                  Icons.trending_up,
                  size: 30,
                ),
              ),
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: CheckboxListTile(
              value: _isUrgent,
              onChanged: (bool val) {
                _isUrgent = val;
                widget.product.isUrgent = _isUrgent;
                setState(() {});
              },
              title: Text(
                "URGENT",
              ),
              subtitle: Text(
                  'Stand out from the rest by showing a bright red marker on the ad'),
              isThreeLine: true,
              secondary: Container(
                child: Icon(
                  Icons.attach_file,
                  size: 30,
                ),
              ),
            ),
          ),
          Divider(),
          ZButtonRaised(
              text: 'Submit',
              onTap: () async {
                bool res = await userProvider.submitAd(
                    product: widget.product, imageAssets: widget.imageAssets);
                if (res) {
                  appProvider.setSelectedPageIndex(index: 0, isInit: false);
                  Navigator.of(context).pop();
                }
              }),
        ],
      )),
    );
  }
}
