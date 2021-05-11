import 'package:classified_flutter/components/drawer_custom.dart';
import 'package:classified_flutter/components/location_custom.dart';

import 'package:classified_flutter/components/z_card_tile.dart';
import 'package:classified_flutter/components/z_categories_view.dart';
import 'package:classified_flutter/components/z_notification.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'categories_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isExpanded = false;
  double _height;
  double _width;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          appBar: AppBar(
            title: LocationCustom(),
            actions: [
              ZNotification(),
              SizedBox(
                width: 10,
              )
            ],
          ),
          drawer: DrawerCustom(),
          body: Container(
            height: _height,
            width: _width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                    child: Material(
                      borderRadius: BorderRadius.circular(30.0),
                      elevation: 8,
                      child: Container(
                        child: TextFormField(
                          cursorColor: Colors.orange[200],
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            prefixIcon: Icon(Icons.search,
                                color: Colors.orange[200], size: 30),
                            hintText: "What're you looking for?",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return CategoriesPage();
                                  },
                                  fullscreenDialog: false));
                            },
                            child: Text(
                              "All Category",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.orange[200],
                              ),
                            )),
                      ],
                    ),
                  ),
                  ZCategoriesView(),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Featured Ad',
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _fetureadAd(),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Most Recent',
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _mostRecent(),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Most Visited',
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _mostVisited(),
                ],
              ),
            ),
          )),
    );
  }

  Widget _fetureadAd() {
    final userProvider = Provider.of<UserProvider>(context);
    return Container(
      height: 250,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Expanded(
              child:
                  ListView(scrollDirection: Axis.horizontal, children: <Widget>[
            for (var prod in userProvider.streamFeaturedAds)
              ZCardTile(
                product: prod,
              )
          ]))
        ],
      ),
    );
  }

  Widget _mostRecent() {
    final userProvider = Provider.of<UserProvider>(context);

    return Container(
      height: 250,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Expanded(
              child:
                  ListView(scrollDirection: Axis.horizontal, children: <Widget>[
            for (var prod in userProvider.streamMostRecentAds)
              ZCardTile(
                product: prod,
              )
          ]))
        ],
      ),
    );
  }

  Widget _mostVisited() {
    final userProvider = Provider.of<UserProvider>(context);

    return Container(
      height: 250,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Expanded(
              child:
                  ListView(scrollDirection: Axis.horizontal, children: <Widget>[
            for (var prod in userProvider.streamMostViewedAds)
              ZCardTile(
                product: prod,
              )
          ]))
        ],
      ),
    );
  }
}
