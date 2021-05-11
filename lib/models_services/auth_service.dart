import 'package:classified_flutter/app_utils/error_handler.dart';
import 'package:classified_flutter/app_utils/success_message_handler.dart';
import 'package:classified_flutter/components/z_bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

import '../models/update.dart';
import '../models/user.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;
  static final FirebaseMessaging _firestoreMessaging = FirebaseMessaging();

/* --------------------------- NOTE Stream Update --------------------------- */
  static Future<Stream<Update>> streamUpdate() async {
    var ref = Firestore.instance
        .collection('general')
        .document('appBuildNumberServer');
    return ref.snapshots().map((snap) => Update.fromFirestore(snap));
  }

  /* ----------------- NOTE Get User i.e Stream<User> != User ----------------- */
  static Future<User> getAuthUser() async {
    FirebaseUser fbUser = await _auth.currentUser();

    User user;
    Stream<User> streamUser;
    if (fbUser != null) {
      streamUser = await streamAuthUser();
      streamUser = streamUser.take(1);
      await for (User i in streamUser) {
        if (i != null) {
          user = i;
        }
      }
    }
    return user;
  }

  /* ---------------------------- NOTE Stream User ---------------------------- */
  static Future<Stream<User>> streamAuthUser() async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      var ref = Firestore.instance
          .collection('users')
          .document(user.uid)
          .snapshots()
          .asBroadcastStream();
      return ref.map((snap) => User.fromFirestore(snap));
    }
    return null;
  }

  /* ------------------------ NOTE Sign in with Email ------------------------ */
  static Future<FirebaseUser> signInUserEmailAndPassword(
      {String email, String password}) async {
    ZBotToast.loadingShow();
    print(email);
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      print(firebaseUser.isEmailVerified);
      if (firebaseUser.isEmailVerified) {
        await _firestore
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'timestampRegister': DateTime.now(),
          'isEmailVerified': true,
        }, merge: true);
      } else {
        ZBotToast.showToastError(message: ErrorHandler.VERIFY_EMAIL);
      }

      return firebaseUser;
    } catch (err) {
      print(err);
      ZBotToast.showToastError(message: ErrorHandler.authErrorHandelar(err));
      return null;
    }
  }

/* --------------------- NOTE Reset Password With email --------------------- */
  static Future<bool> resetPassword({String email}) async {
    try {
      ZBotToast.loadingShow();
      await _auth.sendPasswordResetEmail(email: email);
      ZBotToast.showToastSuccess(message: SuccessMessage.REST_PASSWORD);
      return true;
    } catch (errorCode) {
      ZBotToast.showToastError(
          message: ErrorHandler.authErrorHandelar(errorCode));
      ZBotToast.loadingClose();
      return false;
    }
  }

/* ------------------------ NOTE Register with Email ------------------------ */
  static Future<FirebaseUser> registerUserEmailAndPassword(
      {UserRegister userRegister}) async {
    try {
      ZBotToast.loadingShow();
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: userRegister.email, password: userRegister.password);
      FirebaseUser firebaseUser = authResult.user;
      await registerUserUpdateFirestore(
          fbUser: firebaseUser, userRegister: userRegister);
      await sendEmailVerification();
      return firebaseUser;
    } catch (errorCode) {
      ZBotToast.showToastError(
          message: ErrorHandler.authErrorHandelar(errorCode));
      return null;
    }
  }

  /* --------------------------- NOTE Register User --------------------------- */
  static Future<void> registerUserUpdateFirestore(
      {FirebaseUser fbUser, UserRegister userRegister}) async {
    String currentDevToken = await _firestoreMessaging.getToken();
    final settings = Hive.box('settings');
    String appVersion = settings.get('appVersion');
    num appBuildNumber = int.tryParse(settings.get('appBuildNumber'));

    await _firestore.collection('users').document(fbUser.uid).setData({
      'email': fbUser.email,
      'firstName': userRegister.firstName,
      'lastName': userRegister.lastName,
      'phoneNumber': userRegister.phoneNumber,
      'timestampRegister': DateTime.now(),
      'timestampLastLogin': DateTime.now(),
      'isAdmin': false,
      'devTokens': FieldValue.arrayUnion([currentDevToken]),
      'isNotificationsEnabled': true,
      'appVersion': appVersion,
      'appBuildNumber': appBuildNumber,
      'isEmailVerified': fbUser.isEmailVerified,
      'isRegistrationComplete': false,
    });

    return;
  }

/* ------------------------ NOTE Sign in with Google ------------------------ */
  static Future<FirebaseUser> googleSignIn() async {
    try {
      ZBotToast.loadingShow();
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        AuthResult authResult = await _auth.signInWithCredential(credential);

        FirebaseUser firebaseUser = authResult.user;
        await registerUser(fbUser: firebaseUser);

        return firebaseUser;
      } else {
        ZBotToast.loadingClose();
        ZBotToast.showToastError(message: 'Action cancelled by user');
        return null;
      }
    } catch (error) {
      ZBotToast.loadingClose();
      ZBotToast.showToastSomethingWentWrong();
      return null;
    }
  }

  /* ------------------------ NOTE Anonymous Sign in ------------------------ */
  static Future<FirebaseUser> anonymousSignIn() async {
    ZBotToast.loadingShow();
    try {
      AuthResult auth = await _auth.signInAnonymously();
      FirebaseUser fbUser = auth.user;
      return fbUser;
    } catch (e) {
      ZBotToast.loadingClose();
      ZBotToast.showToastSomethingWentWrong();
      return null;
    }
  }

  /* ----------------------- NOTE Registration  ---------------------- */
  static Future<bool> updateUser({UserRegister userRegister}) async {
    ZBotToast.loadingShow();

    try {
      FirebaseUser fbUser = await _auth.currentUser();
      await _firestore.collection('users').document(fbUser.uid).setData({
        'firstName': userRegister.firstName,
        'lastName': userRegister.lastName,
        'phoneNumber': userRegister.phoneNumber
      }, merge: true);
      return true;
    } catch (e) {
      return false;
    }
  }

/* --------------------------- NOTE Register User --------------------------- */
  static Future<void> registerUser({FirebaseUser fbUser}) async {
    var userRef =
        await _firestore.collection('users').document(fbUser.uid).get();
    final settings = Hive.box('settings');
    String appVersion = settings.get('appVersion');
    num appBuildNumber = int.tryParse(settings.get('appBuildNumber'));
    User user = User.fromFirestore(userRef);
    String currentDevToken = await _firestoreMessaging.getToken();
    if (!userRef.exists) {
      await _firestore.collection('users').document(fbUser.uid).setData({
        'firstName': fbUser.displayName,
        'lastName': '',
        'email': fbUser.email,
        'timestampRegister': user?.timestampRegister ?? DateTime.now(),
        'timestampLastLogin': user?.timestampRegister ?? DateTime.now(),
        'devTokens': FieldValue.arrayUnion([currentDevToken]),
        'isNotificationsEnabled': user?.isNotificationsEnabled ?? true,
        'appVersion': appVersion,
        'appBuildNumber': appBuildNumber,
        'isRegistrationComplete': false,
        'isEmailVerified': true,
        'isActive': true
      }, merge: true);
    }

    return;
  }

/* ---------------------- NOTE Send Email Verification ---------------------- */
  static Future sendEmailVerification() async {
    try {
      FirebaseUser fbUser = await _auth.currentUser();
      await fbUser.sendEmailVerification();
      ZBotToast.showToastSuccess(
          message: 'Email was sent please check and verify');
    } catch (e) {
      ZBotToast.showToastError(message: e.toString());
    }
  }

/* ---------------------- NOTE Check if email verified ---------------------- */
  static Future<bool> isEmailVerified() async {
    ZBotToast.loadingShow();
    FirebaseUser fbUser = await _auth.currentUser();
    await fbUser.reload();

    FirebaseUser fbAuthUser = await _auth.currentUser();

    if (fbAuthUser.isEmailVerified) {
      await _firestore.collection('users').document(fbAuthUser.uid).updateData({
        'isEmailVerified': true,
      });
      ZBotToast.loadingClose();
      return true;
    } else {
      ZBotToast.showToastError(message: 'Email Not verified!');
      return false;
    }
  }

/* --------------------- NOTE Update Notification Status -------------------- */
  static Future<void> updateNotificationStatus(bool status) async {
    FirebaseUser user = await _auth.currentUser();
    await _firestore.collection('users').document(user.uid).updateData({
      'isNotificationsEnabled': status,
    });
  }

/* --------------------- NOTE Update Appversion Login & dev token --------------------- */
  static Future<void> updateAppVersionLastLogin() async {
    String currentDevToken = await _firestoreMessaging.getToken();

    FirebaseUser user = await _auth.currentUser();
    final settings = Hive.box('settings');
    String appVersion = settings.get('appVersion');
    num appBuildNumber = int.tryParse(settings.get('appBuildNumber'));

    if (user != null) {
      await _firestore.collection('users').document(user.uid).updateData({
        'timestampLastLogin': DateTime.now(),
        'devTokens': FieldValue.arrayUnion([currentDevToken]),
        'appVersion': appVersion,
        'appBuildNumber': appBuildNumber
      });
    }
  }

/* ------------------------------ NOTE Sign Out ----------------------------- */
  static Future<bool> signOut() async {
    try {
      FirebaseUser fbUser = await _auth.currentUser();

      String currentDevToken = await _firestoreMessaging.getToken();

      if (fbUser != null) {
        _firestore.collection('users').document(fbUser.uid).updateData({
          'devTokens': FieldValue.arrayRemove([currentDevToken]),
        });
      }
      _auth.signOut();
      _googleSignIn.disconnect();
      _googleSignIn.signOut();
      return true;
    } catch (e) {
      ZBotToast.showToastSomethingWentWrong();
      return false;
    }
  }

/* ------------------------------ NOTE Delete User Account ----------------------------- */
  static Future<bool> deleteAccount() async {
    ZBotToast.loadingShow();
    try {
      FirebaseUser fbUser = await _auth.currentUser();
      fbUser.delete();
      return true;
    } catch (e) {
      ZBotToast.showToastSomethingWentWrong();
      return false;
    }
  }

  static Future httpDeleteUserAccount(User user) async {
    ZBotToast.loadingShow();
    await dio.Dio().post('', data: user.toJson());
  }
}
