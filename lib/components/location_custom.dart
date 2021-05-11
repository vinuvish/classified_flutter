import 'package:flutter/material.dart';

class LocationCustom extends StatelessWidget {
  const LocationCustom({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.height / 20,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.black12,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  print('Editing location');
                },
                child: Icon(
                  Icons.edit_location,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.height / 40,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                  child: Text('Noida',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.height / 50),
                      // overflow: TextOverflow.fade,
                      softWrap: false)),
            ],
          ),
        ),
      ),
    );
  }
}
