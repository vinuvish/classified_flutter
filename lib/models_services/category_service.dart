import 'package:classified_flutter/models/categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore _firestore = Firestore.instance;

class CategoryService {
  static Future<Stream<List<Categories>>> streamCategories() async {
    var ref = _firestore
        .collection('categories')
        .orderBy('name')
        .snapshots()
        .asBroadcastStream();

    return ref.map((list) =>
        list.documents.map((doc) => Categories.fromFirestore(doc)).toList());
  }
}
