import 'dart:async';

import 'package:classified_flutter/app_utils/routes.dart';
import 'package:classified_flutter/models_services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../app_utils/get_it.dart';
import '../app_utils/navigator.dart';
import '../models/update.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final Firestore firestore = Firestore.instance;

  bool _isAnonymous = false;
  bool get isAnonymous => _isAnonymous;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAppStarting = true;
  bool get sAppStarting => _isAppStarting;
  StreamSubscription<User> _streamSubscriptionUser;
  User _authUser;
  User get authUser => _authUser;

  Update _updateAuth = Update();

  Future<User> initState() async {
    _authUser = await AuthService.getAuthUser();

    if (_authUser == null && _isAppStarting) {
      locator<NavigationService>().navigateTo(Constants.ROUTE_ONBOARDING_PAGE);
      _isAppStarting = false;
    }

    if (_authUser != null && !_isAnonymous) {
      Stream<User> streamUser = await AuthService.streamAuthUser();
      _streamSubscriptionUser = streamUser.listen((res) {
        _authUser = res;
        if (res == null) {
          locator<NavigationService>().navigateTo(Constants.ROUTE_SIGN_IN_PAGE);
        }
      });

      Stream<Update> update = await AuthService.streamUpdate();
      update.listen((res) async {
        _updateAuth = res;
        if (_authUser != null) {
          if (_updateAuth.appBuildNumberLocal <
                  _updateAuth.appBuildNumberServer &&
              _updateAuth.isUpdateMandatory) {
            locator<NavigationService>()
                .navigateTo(Constants.ROUTE_UPDATE_APP_PAGE);
          } else {
            if (_authUser.isEmailVerified) {
              locator<NavigationService>()
                  .navigateTo(Constants.ROUTE_HOME_PAGE);
            } else {
              locator<NavigationService>()
                  .navigateTo(Constants.ROUTE_USER_EMAIL_UN_VERIFIED_PAGE);
            }
          }
        }
      });

      FirebaseAuth.instance.onAuthStateChanged.listen((res) async {
        if (res == null) {
          locator<NavigationService>().navigateTo(Constants.ROUTE_SIGN_IN_PAGE);
        }
      });

      AuthService.updateAppVersionLastLogin();
    } else if (_isAnonymous) {
      locator<NavigationService>().navigateTo(Constants.ROUTE_HOME_PAGE);
    }

    return _authUser;
  }

  Future updateNotificationStatus(bool status) async {
    await AuthService.updateNotificationStatus(status);
  }

  Future<User> googleSignIn() async {
    User user;
    FirebaseUser firebaseUser = await AuthService.googleSignIn();
    if (firebaseUser != null) {
      _isAnonymous = false;
      user = await initState();
    }
    return user;
  }

  Future<User> registerUserEmailAndPassword(UserRegister userRegister) async {
    User user;
    var _user = await AuthService.registerUserEmailAndPassword(
        userRegister: userRegister);

    if (_user != null) {
      _isAnonymous = false;
      user = await initState();
    }

    return user;
  }

  Future<FirebaseUser> anonymousSignIn() async {
    FirebaseUser fbuser = await AuthService.anonymousSignIn();

    if (fbuser != null) {
      _isAnonymous = fbuser.isAnonymous;
      await initState();
    }

    return fbuser;
  }

  Future<User> signInUserEmailAndPassword(String email, String password) async {
    User authUser;

    FirebaseUser _user = await AuthService.signInUserEmailAndPassword(
        email: email, password: password);

    if (_user != null) {
      _isAnonymous = false;
      authUser = await initState();
    }

    return authUser;
  }

  Future resetPassword(String email) async {
    bool res = await AuthService.resetPassword(email: email);

    if (res) {
      await Future.delayed(Duration(seconds: 2));

      locator<NavigationService>().navigateTo(Constants.ROUTE_SIGN_IN_PAGE);
    }
  }

  Future sendEmailVerification() async {
    AuthService.sendEmailVerification();
  }

  Future<bool> checkEmailVerification() async {
    bool res = await AuthService.isEmailVerified();
    if (res) {
      initState();
    }
    return res;
  }

  Future updateUser({
    @required UserRegister userRegister,
  }) async {
    bool result = await AuthService.updateUser(
      userRegister: userRegister,
    );
    return result;
  }

  Future<bool> deleteUserAccount() async {
    bool res = await AuthService.deleteAccount();
    if (res) {
      await AuthService.httpDeleteUserAccount(authUser);
    }
    return res;
  }

  void clearStreams() {
    _streamSubscriptionUser?.cancel();
  }

  void clearStates() {
    _authUser = null;
  }

  Future<bool> signOut() async {
    bool res = await AuthService.signOut();
    if (res) {
      clearStreams();
      clearStates();
    }
    return res;
  }
}
