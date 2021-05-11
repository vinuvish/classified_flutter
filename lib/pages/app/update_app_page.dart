import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class UpdateAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('New Update Available'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            AntDesign.warning,
            size: 50,
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Sorry for the inconvenience but could you please update to the newest version of our app.',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.3),
            ),
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
