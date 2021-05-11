import 'package:cached_network_image/cached_network_image.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:classified_flutter/pages/app/filter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ZCategoriesView extends StatelessWidget {
  const ZCategoriesView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 4,
        children: [
          for (var category in provider.streamCategories)
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return FilterPage(category: category);
                    },
                    fullscreenDialog: false));
              },
              child: Column(
                children: [
                  CachedNetworkImage(
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height / 20,
                    width: MediaQuery.of(context).size.height / 20,
                    fadeInCurve: Curves.easeIn,
                    fadeInDuration: Duration(milliseconds: 600),
                    imageUrl: category.imgUrl,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: Text(
                      category.name,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
