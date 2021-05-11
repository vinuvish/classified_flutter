import 'package:classified_flutter/models/user.dart';
import 'package:classified_flutter/models_providers/app_provider.dart';
import 'package:classified_flutter/models_providers/auth_provider.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

import 'package:provider/provider.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 3000)).then((value) async {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      appProvider.setSelectedPageIndex(index: 0, isInit: false);
      User authUser =
          await Provider.of<AuthProvider>(context, listen: false).initState();
      if (authUser != null) {
        await Provider.of<UserProvider>(context, listen: false).initState();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
                child: LoadingBouncingGrid.circle(
              backgroundColor: Theme.of(context).accentColor,
            ))
          ],
        ),
      ),
    );
  }
}
