import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ZBotToast {
  static loadingShow() async {
    await loadingClose();
    BotToast.showCustomLoading(
        toastBuilder: (func) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xFF74b9ff),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0984e3)),
                ),
              ),
              SizedBox(height: 50)
            ],
          );
        },
        allowClick: true,
        clickClose: true,
        backgroundColor: Colors.transparent);
  }

  static showToastSuccess({@required String message, Duration duration}) async {
    await loadingClose();

    BotToast.showCustomText(
        toastBuilder: (func) {
          return Column(
            children: <Widget>[
              Spacer(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                    color: Color(0xFF3886D1),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: <Widget>[
                    Icon(Feather.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            message,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          );
        },
        clickClose: true,
        crossPage: true,
        animationReverseDuration: Duration(seconds: 1),
        animationDuration: Duration(seconds: 1),
        duration: duration ?? Duration(seconds: 5));
  }

  static showToastError({@required String message, Duration duration}) async {
    await loadingClose();

    BotToast.showCustomText(
        toastBuilder: (func) {
          return Column(
            children: <Widget>[
              Spacer(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                    color: Color(0xFFE6532D),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: <Widget>[
                    Icon(Feather.x_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Opps!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(
                            message,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          );
        },
        clickClose: true,
        crossPage: true,
        animationReverseDuration: Duration(seconds: 1),
        animationDuration: Duration(seconds: 1),
        duration: duration ?? Duration(seconds: 5));
  }

  static showNotification(
      {Duration duration,
      @required String title,
      @required String body}) async {
    await loadingClose();

    BotToast.showCustomNotification(
        toastBuilder: (func) {
          return Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                    color: Color(0xFF3886D1),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('$title',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(
                            '$body',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        crossPage: true,
        animationReverseDuration: Duration(seconds: 1),
        animationDuration: Duration(seconds: 1),
        duration: duration ?? Duration(seconds: 5));
  }

  static showToastSomethingWentWrong({Duration duration}) async {
    await loadingClose();

    BotToast.showCustomText(
        toastBuilder: (func) {
          return Column(
            children: <Widget>[
              Spacer(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                    color: Color(0xFFE6532D),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: <Widget>[
                    Icon(Feather.x_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Opps!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(
                            'Something went wrong',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          );
        },
        clickClose: true,
        crossPage: true,
        animationReverseDuration: Duration(seconds: 1),
        animationDuration: Duration(seconds: 1),
        duration: duration ?? Duration(seconds: 5));
  }

  static Future loadingClose() async {
    BotToast.cleanAll();
    await Future.delayed(Duration(milliseconds: 100));
  }
}
