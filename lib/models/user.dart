import 'package:cloud_firestore/cloud_firestore.dart';

import '../app_utils/time_parse.dart';

class User {
  String id;
  String documentID;
  String appVersion;
  num appBuildNumber;
  String email;
  String firstName;
  String lastName;
  String fullName;
  String phoneNumber;
  bool isActive;
  bool isNotificationsEnabled;
  DateTime timestampRegister;
  String timestampRegisterStr;
  DateTime timestampLastLogin;
  String timestampLastLoginStr;
  bool isAdmin;
  bool isEmailVerified;

  User({
    this.id,
    this.documentID,
    this.email,
    this.firstName,
    this.isActive,
    this.timestampRegister,
    this.isNotificationsEnabled,
    this.lastName,
    this.timestampRegisterStr,
    this.timestampLastLoginStr,
    this.timestampLastLogin,
    this.isAdmin,
    this.fullName,
    this.phoneNumber,
    this.appBuildNumber,
    this.appVersion,
    this.isEmailVerified,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    if (data != null) {
      String firstName = data['firstName'] ?? '';
      String lastName = data['lastName'] ?? '';
      String fullname = '$firstName $lastName';

      return User(
        id: doc.documentID,
        documentID: doc.documentID,
        appBuildNumber: data['appBuildNumber'] ?? 0,
        appVersion: data['appVersion'] ?? '',
        email: data['email'] ?? '',
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        fullName: fullname,
        phoneNumber: data['phoneNumber'] ?? '',
        isActive: data['isActive'] ?? true,
        isNotificationsEnabled: data['isNotificationsEnabled'] ?? true,
        timestampRegisterStr:
            TimeParse.formatTimeToString(data['timestampRegister']),
        timestampLastLoginStr:
            TimeParse.formatTimeToString(data['timestampLastLogin']),
        timestampRegister: TimeParse.parseTime(data['timestampRegister']),
        timestampLastLogin: TimeParse.parseTime(data['timestampLastLogin']),
        isEmailVerified: data['isEmailVerified'] ?? true,
      );
    } else {
      return null;
    }
  }

  Map toJson() => {
        'email': email,
        'userUid': documentID,
        'userName': '$firstName $lastName'
      };

  factory User.fromMap(Map<dynamic, dynamic> data) {
    if (data.isEmpty) return null;
    return User(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }
}

class UserRegister {
  String phoneNumber;
  String email;
  String firstName;
  String lastName;
  String password;
  String userType;

  UserRegister(
      {this.email = '',
      this.firstName = '',
      this.lastName = '',
      this.password = '',
      this.phoneNumber = '',
      this.userType = ''});
}
