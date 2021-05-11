import 'package:classified_flutter/app_utils/routes.dart';
import 'package:classified_flutter/app_utils/validator.dart';
import 'package:classified_flutter/components/z_button_raised.dart';
import 'package:classified_flutter/components/z_button_text.dart';
import 'package:classified_flutter/components/z_text_form_field.dart';
import 'package:classified_flutter/models/user.dart';
import 'package:classified_flutter/models_providers/auth_provider.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  UserRegister userRegister = UserRegister();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(
              fontWeight: FontWeight.w700, fontStyle: FontStyle.italic),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Image.asset('assets/images/app_logo.png'),
              height: 0,
            ),
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
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                    User authUser = await authProvider
                        .registerUserEmailAndPassword(userRegister);
                    if (authUser != null && authUser.isEmailVerified) {
                      await Provider.of<UserProvider>(context, listen: false)
                          .initState();
                    }
                  }
                }),
            SizedBox(
              height: 30,
            ),
            ZButtonText(
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(Constants.ROUTE_SIGN_IN_PAGE);
              },
              child: Container(child: Text('Already have an account?')),
            ),
          ],
        ),
      ),
    );
  }
}

class ZBottomNavbarItem {}
