import 'package:classified_flutter/models_providers/auth_provider.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'onboarding_page.dart';

class EmailUnverifiedPage extends StatefulWidget {
  EmailUnverifiedPage({Key key}) : super(key: key);

  @override
  _EmailUnverifiedPageState createState() => _EmailUnverifiedPageState();
}

class _EmailUnverifiedPageState extends State<EmailUnverifiedPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 50),
          Text(
            'Verify your Email',
            style: GoogleFonts.lato(
                fontSize: 26,
                color: Color(0xFF4A4A4A),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'We sent you an email',
            style: GoogleFonts.lato(
                fontSize: 20,
                color: Color(0xFFB0B2BE),
                fontWeight: FontWeight.bold),
          ),
          new Container(
              width: MediaQuery.of(context).size.width * 0.87,
              child: new Image.asset(
                'assets/images/email_unverified.png',
                height: 250,
              )),
          SizedBox(height: 100),
          new GestureDetector(
            onTap: () async {
              bool res = await provider.checkEmailVerification();
              if (res) {
                await Provider.of<UserProvider>(context, listen: false)
                    .initState();
              }
            },
            child: new Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(34, 160, 195, 1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                "Check Verification",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 40),
          new FlatButton(
            child: Text("Resend email", style: TextStyle(color: Colors.grey)),
            onPressed: () async {
              await provider.sendEmailVerification();
            },
          ),
          new FlatButton(
            child: Text("Create new account",
                style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new OnboardingPage()));
            },
          ),
        ],
      ),
    );
  }
}
