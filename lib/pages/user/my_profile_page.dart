import 'package:classified_flutter/components/z_button_icon.dart';
import 'package:classified_flutter/components/z_button_outlined.dart';
import 'package:classified_flutter/components/z_button_raised.dart';
import 'package:classified_flutter/components/z_text_form_field.dart';
import 'package:classified_flutter/models/user.dart';
import 'package:classified_flutter/models_providers/auth_provider.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatefulWidget {
  MyProfilePage({Key key}) : super(key: key);

  @override
  MyProfilePageState createState() => MyProfilePageState();
}

class MyProfilePageState extends State<MyProfilePage> {
  final formKey = GlobalKey<FormState>();
  final formKeyDeletUser = GlobalKey<FormState>();
  String email;
  bool _isEdit = false;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    UserRegister userRegister = UserRegister();
    return Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
          actions: [
            ZButtonIcon(icon: AntDesign.edit, onTap: _enableEdit),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Form(
            key: formKey,
            child: ListView(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(16, 16, 12, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("${userProvider.authUser.fullName}"),
                        SizedBox(height: 4),
                        Text("${userProvider.authUser.email}"),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.fromLTRB(16, 16, 12, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ZTextFormField(
                          isEnabled: _isEdit,
                          hint: 'First Name',
                          initialValue: userProvider.authUser.firstName,
                          onValueChanged: (value) {
                            userRegister.firstName = value;
                          },
                          onSaved: (value) {
                            userRegister.firstName = value;
                          },
                        ),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.fromLTRB(16, 0, 12, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ZTextFormField(
                          isEnabled: _isEdit,
                          hint: 'Last Name',
                          initialValue: userProvider.authUser.lastName,
                          onValueChanged: (value) {
                            userRegister.lastName = value;
                          },
                          onSaved: (value) {
                            userRegister.lastName = value;
                          },
                        ),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.fromLTRB(16, 0, 12, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ZTextFormField(
                          isEnabled: _isEdit,
                          hint: 'Phone Number',
                          initialValue: userProvider.authUser.phoneNumber,
                          onValueChanged: (value) {
                            userRegister.phoneNumber = value;
                          },
                          onSaved: (value) {
                            userRegister.phoneNumber = value;
                          },
                        ),
                      ],
                    )),
                if (_isEdit)
                  ZButtonRaised(
                      text: 'Update',
                      onTap: () async {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          bool result = await authProvider.updateUser(
                            userRegister: userRegister,
                          );
                          if (result) Navigator.pop(context);
                        }
                      }),
                if (_isEdit)
                  ZButtonRaised(
                      text: 'Delete Account',
                      onTap: () async {
                        _deleteAcoundBuilder(context);
                      }),
              ],
            )));
  }

  _enableEdit() {
    _isEdit = !_isEdit;

    setState(() {});
  }

  Future<String> _deleteAcoundBuilder(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm your Email'),
          content: Container(
            width: 260.0,
            height: 210.0,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Form(
                    key: formKeyDeletUser,
                    child: ZTextFormField(
                      hint: 'Email',
                      validator: (value) {
                        if (value != authProvider.authUser.email) {
                          return 'Invalid Email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email = value;
                      },
                      onValueChanged: (value) {
                        email = value;
                      },
                    )),
                ZButtonOutline(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    text: 'Confirm',
                    onTap: () async {
                      if (formKeyDeletUser.currentState.validate()) {
                        formKeyDeletUser.currentState.save();
                        // await authProvider.deleteUserAccount();
                        // userProvider.clearStreams();
                        // userProvider.clearAllStates();
                        // appProvider.setSelectedPageIndex(index: 0);
                      }
                    }),
                ZButtonOutline(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  text: 'Cancel',
                  textColor: Colors.red,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
