import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ZImageDisplay extends StatelessWidget {
  const ZImageDisplay(
      {Key key,
      @required this.imageUrl,
      this.height,
      this.width,
      this.borderRadius})
      : super(key: key);

  final String imageUrl;
  final double height;
  final double width;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(0),
      child: Container(
        alignment: Alignment.center,
        height: height ?? 85,
        width: width ?? 85,
        child: imageUrl != ''
            ? CachedNetworkImage(
                fit: BoxFit.cover,
                width: double.infinity,
                fadeInCurve: Curves.easeIn,
                fadeInDuration: Duration(milliseconds: 500),
                imageUrl: imageUrl,
                placeholder: (context, url) => Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Icon(
                          //   AntDesign.picture,
                          //   size: 45,
                          //   color: Colors.black26,
                          // ),
                          // SizedBox(
                          //   height: 4,
                          // ),
                          // Text(
                          //   'Error',
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(color: Colors.black45, fontSize: 12.5),
                          // ),
                        ],
                      ),
                    )),
              )
            : Container(
                alignment: Alignment.center,
                height: double.infinity,
                width: double.infinity,
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Icon(
                    //   AntDesign.picture,
                    //   size: 45,
                    //   color: Colors.black26,
                    // ),
                    // SizedBox(
                    //   height: 4,
                    // ),
                    // Text(
                    //   'No Image',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(color: Colors.black45, fontSize: 12.5),
                    // ),
                  ],
                ),
              ),
      ),
    );
  }
}
