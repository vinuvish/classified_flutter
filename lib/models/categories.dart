import 'package:classified_flutter/models/subCategories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Categories {
  String documentId;
  String id;
  String imgUrl;
  String name;
  List<SubCategories> subCategories;
  SubCategories productSubCategory;

  Categories(
      {this.documentId,
      this.id,
      this.imgUrl,
      this.name,
      this.subCategories,
      this.productSubCategory});

  factory Categories.fromFirestore(DocumentSnapshot document) {
    Map data = document.data;

    if (data == null) return null;
    return Categories(
        documentId: document.documentID,
        id: document.documentID,
        imgUrl: data['imgUrl'] ?? '',
        name: data['name'] ?? '',
        subCategories: getSubCategories(data['subCategories'] ?? {}) ?? {});
  }

  static List<SubCategories> getSubCategories(dynamic data) {
    List<SubCategories> subCategories = [];
    if (data != {}) {
      data.forEach((k, v) {
        SubCategories subC = SubCategories.fromMap(v);
        subCategories.add(subC);
      });
    }
    return subCategories;
  }
}
