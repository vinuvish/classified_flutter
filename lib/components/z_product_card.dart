import 'package:classified_flutter/components/z_card.dart';
import 'package:classified_flutter/models/product.dart';
import 'package:classified_flutter/pages/app/ad_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'z_image_display.dart';

class ZProductCard extends StatefulWidget {
  final Product product;
  ZProductCard({Key key, this.product}) : super(key: key);

  @override
  _ZProductCardState createState() => _ZProductCardState();
}

class _ZProductCardState extends State<ZProductCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          ZCard(
            onTap: () async {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return AdDetailsPage(product: widget.product);
                  },
                  fullscreenDialog: false));
            },
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            padding: EdgeInsets.all(0),
            child: Container(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          ZImageDisplay(
                            height: 120,
                            width: 120,
                            borderRadius: BorderRadius.circular(5),
                            imageUrl: widget.product.imgUrls[0],
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
                                    ) // green shaped
                                    ),
                                child: Text(
                                  "URGENT",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(left: 15, top: 0),
                            child: Text(widget.product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: widget.product.title.length > 15
                                        ? 15
                                        : 18,
                                    fontWeight: FontWeight.w500)),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(left: 15, top: 5),
                            child: Text(
                                '${widget.product.category},${widget.product.subCategory}',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500)),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 15, top: 10),
                            child: Icon(
                              Icons.location_on,
                              size: 12,
                              color: Color(0xFFfb3132),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(left: 0, top: 10),
                            child: Text(
                                '${widget.product.district},${widget.product.city}',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500)),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(left: 17, top: 10),
                              child: Text('\$ ${widget.product.price}',
                                  style: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            ),
                            //  Spacer(),
                            Container(
                              padding: EdgeInsets.only(left: 5, top: 10),
                              child: Text(
                                  '${DateTime.now().difference(widget.product.timestampAdded).inDays} days',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
