import 'package:classified_flutter/app_utils/routes.dart';
import 'package:classified_flutter/app_utils/validator.dart';
import 'package:classified_flutter/components/z_button_icon.dart';
import 'package:classified_flutter/components/z_button_text.dart';
import 'package:classified_flutter/components/z_text_form_field.dart';
import 'package:classified_flutter/models/user.dart';
import 'package:classified_flutter/models_providers/auth_provider.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../components/z_button_raised.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Post ITT.',
              style: GoogleFonts.lato(
                  fontStyle: FontStyle.italic,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                height: 2,
                width: 50,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.blue,
                        style: BorderStyle.solid,
                        width: 2)),
              ),
            ],
          ),
          SizedBox(height: 20),
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                ZTextFormField(
                  hint: 'Email',
                  validator: (value) => EmailValidator.validate(value),
                  onSaved: (value) {
                    email = value.trim().toLowerCase();
                  },
                  onValueChanged: (value) {
                    email = value.trim().toLowerCase();
                  },
                ),
                ZTextFormField(
                  hint: 'Password',
                  obscureText: true,
                  onSaved: (value) {
                    password = value;
                  },
                  onValueChanged: (value) {
                    password = value;
                  },
                ),
              ],
            ),
          ),
          ZButtonRaised(
            onTap: () async {
              if (formKey.currentState.validate()) {
                formKey.currentState.save();
                User authUser = await authProvider.signInUserEmailAndPassword(
                    email, password);
                if (authUser != null && authUser.isEmailVerified) {
                  await Provider.of<UserProvider>(context, listen: false)
                      .initState();
                }
              }
            },
            text: 'Sign In',
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ZButtonText(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(Constants.ROUTE_RESET_PASSWORD);
                },
                child: Text('Forgot password?'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Continue with',
              style: GoogleFonts.lato(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ZButtonIcon(
                  icon: AntDesign.google,
                  size: 40,
                  color: Colors.red,
                  onTap: () async {
                    User authUser = await authProvider.googleSignIn();
                    if (authUser != null) {
                      await Provider.of<UserProvider>(context, listen: false)
                          .initState();
                    }
                  },
                ),
                SizedBox(width: 30),
                ZButtonIcon(
                  icon: AntDesign.facebook_square,
                  size: 40,
                  color: Colors.blue,
                  onTap: () async {
                    User authUser = await authProvider.googleSignIn();
                    if (authUser != null) {
                      await Provider.of<UserProvider>(context, listen: false)
                          .initState();
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          ZButtonText(
            onTap: () async {
              FirebaseUser authUser = await authProvider.anonymousSignIn();
              if (authUser != null) {
                await Provider.of<UserProvider>(context, listen: false)
                    .initState();
              }
            },
            child: Text('Gust Login'),
          ),
          SizedBox(height: 50),
          ZButtonText(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(Constants.ROUTE_SIGN_UP_PAGE);
            },
            child: Text('Dont have an account?'),
          ),
        ],
      ),
    );
  }
}
