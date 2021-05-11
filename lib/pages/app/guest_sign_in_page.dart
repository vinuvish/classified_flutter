import 'package:classified_flutter/app_utils/routes.dart';
import 'package:classified_flutter/app_utils/validator.dart';
import 'package:classified_flutter/components/z_button_icon.dart';
import 'package:classified_flutter/components/z_button_text.dart';
import 'package:classified_flutter/components/z_text_form_field.dart';
import 'package:classified_flutter/models/user.dart';
import 'package:classified_flutter/models_providers/app_provider.dart';
import 'package:classified_flutter/models_providers/auth_provider.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../components/z_button_raised.dart';

class GuestSignInPage extends StatefulWidget {
  GuestSignInPage({Key key}) : super(key: key);

  @override
  _GuestSignInPageState createState() => _GuestSignInPageState();
}

class _GuestSignInPageState extends State<GuestSignInPage> {
  final formKeySignIn = GlobalKey<FormState>();
  final formKeySignUp = GlobalKey<FormState>();

  bool isSignup = true;
  UserRegister userRegister = UserRegister();
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              isSignup
                  ? 'Sign up to manage your account'
                  : 'Sign in your account',
              style: GoogleFonts.lato(
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: 20),
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
                    // await authProvider.signOut();
                    User authUser = await authProvider.googleSignIn();

                    if (authUser != null) {
                      await Provider.of<UserProvider>(context, listen: false)
                          .initState();
                      appProvider.setSelectedPageIndex(index: 0, isInit: false);
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
                      appProvider.setSelectedPageIndex(index: 0, isInit: false);
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Or',
              style: GoogleFonts.lato(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
          ),
          if (isSignup) _signUp(),
          if (!isSignup) _signIn(),
          SizedBox(height: 10),
          ZButtonText(
            onTap: () {
              isSignup = !isSignup;
              setState(() {});
            },
            child: Text(
              isSignup ? 'Already have an Account?' : 'Create an Account',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signIn() {
    final authProvider = Provider.of<AuthProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    return Column(
      children: [
        Form(
          key: formKeySignIn,
          child: Column(
            children: <Widget>[
              ZTextFormField(
                hint: 'Email',
                validator: (value) => EmailValidator.validate(value),
                onSaved: (value) {
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
            if (formKeySignIn.currentState.validate()) {
              formKeySignIn.currentState.save();
              User authUser = await authProvider.signInUserEmailAndPassword(
                  email, password);
              if (authUser != null && authUser.isEmailVerified) {
                await Provider.of<UserProvider>(context, listen: false)
                    .initState();
                appProvider.setSelectedPageIndex(index: 0, isInit: false);
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
                Navigator.of(context).pushNamed(Constants.ROUTE_RESET_PASSWORD);
              },
              child: Text('Forgot password?'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _signUp() {
    final appProvider = Provider.of<AppProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Form(
        key: formKeySignUp,
        child: Column(
          children: <Widget>[
            ZTextFormField(
              hint: 'First Name',
              onSaved: (value) {
                userRegister.firstName = value.trim();
              },
            ),
            ZTextFormField(
              hint: 'Last Name',
              onSaved: (value) {
                userRegister.lastName = value.trim();
              },
            ),
            ZTextFormField(
              hint: 'Phone',
              onSaved: (value) {
                userRegister.phoneNumber = value.trim();
              },
            ),
            ZTextFormField(
                hint: 'Email',
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  userRegister.email = value.trim().toLowerCase();
                },
                validator: (String value) => EmailValidator.validate(value)),
            ZTextFormField(
              hint: 'Password',
              obscureText: true,
              validator: (String value) {
                if (value.isEmpty || value.length < 6) {
                  return 'Min length for password is 6';
                }
                return null;
              },
              onSaved: (value) {
                userRegister.password = value;
              },
            ),
            ZButtonRaised(
                text: 'Sign Up',
                onTap: () async {
                  if (formKeySignUp.currentState.validate()) {
                    formKeySignUp.currentState.save();
                    User authUser = await authProvider
                        .registerUserEmailAndPassword(userRegister);
                    if (authUser != null && authUser.isEmailVerified) {
                      await Provider.of<UserProvider>(context, listen: false)
                          .initState();
                      appProvider.setSelectedPageIndex(index: 0, isInit: false);
                    }
                  }
                }),
          ],
        ));
  }
}
