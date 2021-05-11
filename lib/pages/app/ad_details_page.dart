import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:classified_flutter/components/z_bot_toast.dart';
import 'package:classified_flutter/components/z_button_icon.dart';
import 'package:classified_flutter/components/z_button_outlined.dart';
import 'package:classified_flutter/components/z_button_text.dart';
import 'package:classified_flutter/components/z_card_tile.dart';
import 'package:classified_flutter/models/product.dart';
import 'package:classified_flutter/models_providers/auth_provider.dart';
import 'package:classified_flutter/models_providers/theme_provider.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AdDetailsPage extends StatefulWidget {
  final Product product;
  AdDetailsPage({Key key, this.product}) : super(key: key);

  @override
  _AdDetailsPageState createState() => _AdDetailsPageState();
}

class _AdDetailsPageState extends State<AdDetailsPage> {
  final textController = TextEditingController();
  bool isChatOpen = false;
  String newMessage = 'Is this still available?';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Ad Details'),
        actions: [IconButton(icon: Icon(AntDesign.sharealt), onPressed: null)],
      ),
      body: _bodyBuilder(),
    );
  }

  Widget _bodyBuilder() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return ListView(
      children: [
        CarouselSlider.builder(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height / 3,
              autoPlay: false,
              enlargeCenterPage: true,
              viewportFraction: 0.85,
              aspectRatio: 5.0,
              initialPage: 0,
            ),
            itemCount: widget.product.imgUrls.length,
            itemBuilder: (BuildContext context, int itemIndex) => Container(
                    child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: double.infinity,
                  fadeInCurve: Curves.easeIn,
                  fadeInDuration: Duration(milliseconds: 600),
                  imageUrl: widget.product.imgUrls[itemIndex],
                ))),
        Divider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Text(
                  widget.product.title,
                  maxLines: 5,
                  softWrap: true,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
              child: Icon(
                Icons.remove_red_eye,
                size: 15,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(5, 8, 25, 5),
              child: Text(
                '${widget.product.viewsCount}',
                style: TextStyle(fontSize: 10),
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Text(
                '${widget.product.price}\$',
                style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrangeAccent),
              ),
            ),
            Spacer(),
            if (!authProvider.isAnonymous &&
                widget.product.user.id != userProvider.authUser.id)
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: ZButtonIcon(
                    icon: AntDesign.phone,
                    size: 25,
                    onTap: () {
                      _callPhone(widget.product.user.phoneNumber);
                    }),
              ),
            if (!authProvider.isAnonymous &&
                widget.product.user.id != userProvider.authUser.id)
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                child: ZButtonIcon(
                    icon: AntDesign.message1,
                    size: 25,
                    onTap: () {
                      isChatOpen = !isChatOpen;
                      setState(() {});
                    }),
              )
          ],
        ),
        if (isChatOpen)
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: themeProvider.isLightTheme
                  ? Colors.grey[400]
                  : Colors.blueGrey,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: newMessage,
                      hintStyle: TextStyle(),
                    ),
                    onChanged: (value) {
                      newMessage = value;
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                  ),
                  onPressed: () {
                    if (newMessage.isNotEmpty) {
                      userProvider.sendChatMessage(
                          msg: newMessage, product: widget.product);
                      textController.clear();
                      isChatOpen = !isChatOpen;
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
        Divider(),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Row(
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Text(
                      widget.product.timestampAddedStr,
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Row(
                  children: [
                    Text(
                      'Location',
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Icon(
                      Icons.location_on,
                      size: 15,
                    ),
                    Text(
                      widget.product.city,
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: Row(
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.product.category,
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          widget.product.subCategory,
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                width: MediaQuery.of(context).size.width,
                color: themeProvider.isLightTheme
                    ? Colors.grey[400]
                    : Color(0xFF2A2C36),
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Text(
                  'Details',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                  ),
                ),
              ),
              for (var key in widget.product.optionDetails.keys)
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                      child: Row(
                        children: [
                          Text(
                            key,
                            style: TextStyle(fontSize: 12),
                          ),
                          Spacer(),
                          Text(
                            widget.product.optionDetails[key],
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: themeProvider.isLightTheme
                    ? Colors.grey[400]
                    : Color(0xFF2A2C36),
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                child: Text(
                  'Description',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 5, 10),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${widget.product.description}',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                width: MediaQuery.of(context).size.width,
                color: themeProvider.isLightTheme
                    ? Colors.grey[400]
                    : Color(0xFF2A2C36),
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                child: Text(
                  'Post By',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                child: Row(
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(fontSize: 12),
                    ),
                    Spacer(),
                    Text(
                      widget.product.user.fullName,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                child: Row(
                  children: [
                    Text(
                      'Phone Number',
                      style: TextStyle(fontSize: 12),
                    ),
                    Spacer(),
                    Text(
                      widget.product.user.phoneNumber,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Divider(),
              ZButtonOutline(text: 'Promote this ad', onTap: () {})
            ],
          ),
        ),
        ZButtonText(child: Text('Report Ad')),
        Divider(),
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
          alignment: Alignment.bottomLeft,
          child: Text(
            'Similar Ads',
            style: GoogleFonts.lato(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _similarAd()
      ],
    );
  }

  Widget _similarAd() {
    final userProvider = Provider.of<UserProvider>(context);

    return Container(
      height: 250,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Expanded(
              child:
                  ListView(scrollDirection: Axis.horizontal, children: <Widget>[
            for (var prod in userProvider.streamSimilarAds)
              if (prod.subCategoryId == widget.product.subCategoryId)
                ZCardTile(
                  product: prod,
                )
          ]))
        ],
      ),
    );
  }

  _callPhone(String number) async {
    if (await canLaunch('tel:$number')) {
      await launch('tel:$number');
    } else {
      throw 'Could not Call Phone';
    }
  }
}
