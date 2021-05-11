import 'package:classified_flutter/components/z_bot_toast.dart';
import 'package:classified_flutter/models/categories.dart';
import 'package:classified_flutter/models/product.dart';
import 'package:classified_flutter/models/subCategories.dart';
import 'package:classified_flutter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'image_service.dart';

class AdService {
  static final Firestore _firestore = Firestore.instance;

  static Future<Stream<List<Product>>> streamUserProducts({User user}) async {
    print(user.fullName);
    var ref = _firestore
        .collection('products')
        .where('user.id', isEqualTo: user?.id)
        .orderBy('timestampAdded', descending: true)
        .limit(50)
        .snapshots()
        .asBroadcastStream();

    return ref.map((list) =>
        list.documents.map((doc) => Product.fromFirestore(doc)).toList());
  }

  static Future<Stream<List<Product>>> streamSimilerProducts(
      {User user, Product product}) async {
    var ref = _firestore
        .collection('products')
        .where('user.id', isGreaterThan: user.id)
        .where('isLive', isEqualTo: true)
        .where('isSold', isEqualTo: false)
        .where('isblocked', isEqualTo: false)
        .where('categoryId', isEqualTo: product.categoryId)
        .where('subCategoryId', isEqualTo: product.subCategoryId)
        .orderBy('viewsCount', descending: false)
        .orderBy('timestampAdded', descending: true)
        .limit(50)
        .snapshots()
        .asBroadcastStream();

    return ref.map((list) =>
        list.documents.map((doc) => Product.fromFirestore(doc)).toList());
  }

  static Future<Stream<List<Product>>> streamAllProducts(
      {Categories category, SubCategories subCategory}) async {
    var ref = _firestore
        .collection('products')
        .where('isLive', isEqualTo: true)
        .where('isSold', isEqualTo: false)
        .where('isblocked', isEqualTo: false)
        .where('categoryId', isEqualTo: category?.documentId)
        .where('subCategoryId', isEqualTo: subCategory?.id)
        .orderBy('timestampAdded', descending: true)
        .limit(50)
        .snapshots()
        .asBroadcastStream();

    return ref.map((list) =>
        list.documents.map((doc) => Product.fromFirestore(doc)).toList());
  }

  static Future<Stream<List<Product>>> streamAllProductsPagination(
      {Product product, Categories category, SubCategories subCategory}) async {
    var ref = _firestore
        .collection('products')
        .where('isLive', isEqualTo: true)
        .where('isSold', isEqualTo: false)
        .where('isblocked', isEqualTo: false)
        .where('categoryId', isEqualTo: category?.documentId ?? null)
        .where('subCategoryId', isEqualTo: subCategory?.id)
        .orderBy('timestampAdded', descending: true)
        .startAfter([product.timestampAdded])
        .limit(20)
        .snapshots()
        .asBroadcastStream();

    return ref.map((list) =>
        list.documents.map((doc) => Product.fromFirestore(doc)).toList());
  }

  static Future<Stream<List<Product>>> streamFeaturedProducts() async {
    var ref = _firestore
        .collection('products')
        .where('isLive', isEqualTo: true)
        .where('isSold', isEqualTo: false)
        .where('isblocked', isEqualTo: false)
        .where('isfeatured', isEqualTo: true)
        .orderBy('timestampAdded', descending: true)
        .limit(100)
        .snapshots()
        .asBroadcastStream();

    return ref.map((list) =>
        list.documents.map((doc) => Product.fromFirestore(doc)).toList());
  }

  static Future<Stream<List<Product>>> streamMostRecentProducts() async {
    var ref = _firestore
        .collection('products')
        .where('isLive', isEqualTo: true)
        .where('isSold', isEqualTo: false)
        .where('isblocked', isEqualTo: false)
        .orderBy('timestampAdded', descending: true)
        .limit(20)
        .snapshots()
        .asBroadcastStream();

    return ref.map((list) =>
        list.documents.map((doc) => Product.fromFirestore(doc)).toList());
  }

  static Future<Stream<List<Product>>> streamMostViewedProducts() async {
    var ref = _firestore
        .collection('products')
        .where('isLive', isEqualTo: true)
        .where('isSold', isEqualTo: false)
        .where('isblocked', isEqualTo: false)
        .orderBy('viewsCount', descending: true)
        .orderBy('timestampAdded', descending: true)
        .limit(20)
        .snapshots()
        .asBroadcastStream();

    return ref.map((list) =>
        list.documents.map((doc) => Product.fromFirestore(doc)).toList());
  }

  static increaseViewCount({Product product}) {
    try {
      _firestore
          .collection('products')
          .document(product.id)
          .setData({'viewsCount': FieldValue.increment(1)}, merge: true);
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> submitAdService(
      {Product product, User user, List<Asset> imageAsset}) async {
    try {
      ZBotToast.loadingShow();
      List<String> imageUrls = [];
      if (imageAsset.isNotEmpty) {
        imageUrls = await ImageService.uploadMultipleImgFireStorageInt(
            assetList: imageAsset);
      } else {
        ZBotToast.showToastError(message: 'Please Select images');
        return false;
      }
      await _firestore.collection('products').document(product.id).setData({
        'timestampAdded': DateTime.now(),
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'user': {
          'id': user.id,
          'fullName': user.fullName,
          'firstName': user.firstName,
          'lastName': user.lastName,
          'phoneNumber': user.phoneNumber,
          'email': user.email,
        },
        'category': product.category,
        'categoryId': product.categoryId,
        'subCategory': product.subCategory,
        'subCategoryId': product.subCategoryId,
        'optionDetails': product.optionDetails,
        'imgUrls': imageUrls,
        'country': product.country,
        'district': product.district,
        'city': product.city,
        'viewsCount': 1,
        'isfeatured': product.isfeatured,
        'isUrgent': product.isUrgent,
        'isSold': false,
        'isLive': true,
        'isblocked': false,
      }, merge: true);
      ZBotToast.showToastSuccess(message: 'Your Ad on live');
      return true;
    } catch (e) {
      ZBotToast.showToastSomethingWentWrong();
      print(e);
      return false;
    }
  }
}
