import 'dart:io';
import 'package:classified_flutter/app_utils/routes.dart';
import 'package:classified_flutter/components/z_button_raised.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key key}) : super(key: key);

  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final int _totalPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        child: Container(
          child: PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              _currentPage = page;
              setState(() {});
            },
            children: <Widget>[
              _buildPageContent(
                  image: 'assets/images/onboarding1.png',
                  title: 'State of Mind Tracking',
                  body:
                      'Rate each session, view your progress and achieve your long term goals. - Improve yourself - Improve your life.'),
              _buildPageContent(
                  image: 'assets/images/onboarding2.png',
                  title: 'Go forth',
                  body:
                      'At EWLD Sports, we make sure our app is the best tool in YOUR development. Allow your mentors the insight they need to further your training, making sure you reach your peak performance.'),
              _buildPageContent(
                  image: 'assets/images/onboarding3.png',
                  title: 'Efficiency is key',
                  body:
                      'Our app is streamlined for core functionality, designed to build the best YOU.')
            ],
          ),
        ),
      ),
      bottomSheet: _currentPage != 2
          ? _buildSkipNextButton()
          : ZButtonRaised(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              text: 'Get Started Now',
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(Constants.ROUTE_SIGN_IN_PAGE),
            ),
    );
  }

  Widget _buildSkipNextButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              _pageController.animateToPage(2,
                  duration: Duration(milliseconds: 400), curve: Curves.linear);
              setState(() {});
            },
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Text(
              'SKIP',
              style: TextStyle(
                  color: Color(0xFF0074E4), fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            child: Row(children: [
              for (int i = 0; i < _totalPages; i++)
                i == _currentPage
                    ? _buildPageIndicator(true)
                    : _buildPageIndicator(false)
            ]),
          ),
          FlatButton(
            onPressed: () {
              _pageController.animateToPage(_currentPage + 1,
                  duration: Duration(milliseconds: 400), curve: Curves.linear);
              setState(() {});
            },
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Text(
              'NEXT',
              style: TextStyle(
                  color: Color(0xFF0074E4), fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 550),
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Widget _buildPageContent({
    String image,
    String title,
    String body,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(image),
          ),
          SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
                fontStyle: FontStyle.italic,
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            body,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 50,
          ),
          if (_currentPage == 2)
            Container(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  child: Text(
                    'Terms & Condition ',
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.lato(
                        color: Theme.of(context).textTheme.headline1.color,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        textStyle: TextStyle(
                          decoration: TextDecoration.underline,
                        )),
                  ),
                  onTap: () async {
                    const policyUrl = '';
                    try {
                      if (Platform.isIOS) {
                        await launch(policyUrl, forceSafariVC: false);
                      } else {
                        await launch(policyUrl);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                )),
        ],
      ),
    );
  }
}
