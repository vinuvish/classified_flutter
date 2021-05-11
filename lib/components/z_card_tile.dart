import 'package:cached_network_image/cached_network_image.dart';
import 'package:classified_flutter/models/product.dart';
import 'package:classified_flutter/models_providers/theme_provider.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:classified_flutter/pages/app/ad_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ZCardTile extends StatefulWidget {
  final Product product;
  ZCardTile({Key key, this.product}) : super(key: key);

  @override
  _ZCardTileState createState() => _ZCardTileState();
}

class _ZCardTileState extends State<ZCardTile> {
  double _width;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    final theamProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            userProvider.increaseViewCount(widget.product);
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) {
                  return AdDetailsPage(product: widget.product);
                },
                fullscreenDialog: false));
          },
          child: Container(
            width: _width / 2.35,
            height: 230,
            padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
            child: Card(
                color: theamProvider.isLightTheme
                    ? Colors.grey[100]
                    : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Container(
                  width: _width / 2.35,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(
                                  height: 130,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  fadeInCurve: Curves.easeIn,
                                  fadeInDuration: Duration(milliseconds: 500),
                                  imageUrl: widget.product.imgUrls[0],
                                ),
                              ),
                            ),
                          ),
                          if (widget.product.isUrgent)
                            Positioned(
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 6),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        topLeft:
                                            Radius.circular(6)) // green shaped
                                    ),
                                child: Text(
                                  "URGENT",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                            )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.only(left: 6, top: 5),
                              child: Text(widget.product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Color(0xFF6e6e71),
                                      fontSize: widget.product.title.length > 10
                                          ? 11
                                          : 15,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(5)),
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(right: 0, left: 5),
                            child: Container(
                                height: 18,
                                width: 40,
                                child: Row(
                                  children: [
                                    Text(
                                      widget.product.category,
                                      style: TextStyle(fontSize: 9),
                                    )
                                    // Icon(
                                    //   Icons.verified_user,
                                    //   color: Color(0xFFfb3132),
                                    //   size: 16,
                                    // ),
                                  ],
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 5, top: 5),
                                child: Icon(
                                  Icons.location_on,
                                  size: 12,
                                  color: Color(0xFFfb3132),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 5, top: 5),
                                child: Text(
                                    '${widget.product.district}, ${widget.product.city}',
                                    style: TextStyle(
                                        color: Color(0xFF6e6e71),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 10, top: 5, bottom: 10),
                        child: Text('\$${widget.product.price}',
                            style: TextStyle(
                                color: Color(0xFF6e6e71),
                                fontSize: 15,
                                fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
