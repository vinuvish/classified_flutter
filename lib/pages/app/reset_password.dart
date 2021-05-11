import 'package:classified_flutter/app_utils/validator.dart';
import 'package:classified_flutter/components/z_button_raised.dart';
import 'package:classified_flutter/components/z_text_form_field.dart';
import 'package:classified_flutter/models_providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({Key key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String email = '';
  final formKeyForgetPw = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Password Reset'),
      ),
      body: Form(
        key: formKeyForgetPw,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 40),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: <Widget>[
                  Text(
                    'Forgot your password?',
                    style: Theme.of(context).textTheme.headline,
                  ),
                  SizedBox(height: 15),
                  Text('Please enter your email below.'),
                ],
              ),
            ),
            SizedBox(height: 40),
            ZTextFormField(
                hint: 'Email',
                onSaved: (value) {
                  email = value.toLowerCase().trim();
                },
                validator: (String value) => EmailValidator.validate(value)),
            ZButtonRaised(
              text: 'Submit',
              onTap: () {
                if (formKeyForgetPw.currentState.validate()) {
                  formKeyForgetPw.currentState.save();
                  authProvider.resetPassword(email);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
