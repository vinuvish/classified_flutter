import 'package:classified_flutter/app_utils/time_parse.dart';
import 'package:classified_flutter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String documentId;
  String id;
  User user;
  DateTime timestampAdded;
  String timestampAddedStr;
  String title;
  String description;
  String price;
  String category;
  String categoryId;
  String subCategory;
  String subCategoryId;
  Map<dynamic, dynamic> optionDetails;
  List imgUrls;
  bool isfeatured;
  bool isUrgent;
  String country;
  String district;
  String city;
  num viewsCount;
  bool isSold;
  bool isLive;
  bool isblocked;

  GeoPoint geopoint;
  Product(
      {this.documentId,
      this.id,
      this.timestampAdded,
      this.timestampAddedStr,
      this.title,
      this.description,
      this.price,
      this.user,
      this.category,
      this.categoryId,
      this.subCategory,
      this.subCategoryId,
      this.optionDetails,
      this.imgUrls,
      this.isfeatured,
      this.isUrgent,
      this.country,
      this.district,
      this.city,
      this.viewsCount,
      this.geopoint,
      this.isSold,
      this.isLive,
      this.isblocked});

  factory Product.fromFirestore(DocumentSnapshot document) {
    var data = document.data;

    if (data == null) {
      return null;
    }

    return Product(
      documentId: document.documentID,
      id: document.documentID,
      timestampAdded: TimeParse.parseTime(data['timestampAdded'] ?? '') ?? '',
      timestampAddedStr:
          TimeParse.formatTimeToString(data['timestampAdded'] ?? '') ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: data['price'] ?? '',
      user: getUser(data['user'] ?? '') ?? '',
      category: data['category'] ?? '',
      categoryId: data['categoryId'] ?? '',
      subCategory: data['subCategory'] ?? '',
      subCategoryId: data['subCategoryId'] ?? '',
      optionDetails: getOptionDetails(data['optionDetails'] ?? {}) ?? {},
      imgUrls: data['imgUrls'] ?? '',
      country: data['country'] ?? '',
      district: data['district'] ?? '',
      city: data['city'] ?? '',
      viewsCount: data['viewsCount'] ?? 0,
      isfeatured: data['isfeatured'] ?? false,
      isUrgent: data['isUrgent'] ?? false,
      isSold: data['isSold'] ?? false,
      isLive: data['isLive'] ?? true,
      isblocked: data['isblocked'] ?? false,
    );
  }

  static User getUser(Map data) {
    return User(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }

  static Map<dynamic, dynamic> getOptionDetails(data) {
    Map<String, dynamic> optionDetails = {};
    if (data != {}) {
      data.forEach((k, v) {
        optionDetails[k] = v;
      });
    }
    return optionDetails;
  }
}
