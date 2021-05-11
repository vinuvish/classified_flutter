import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../models/user.dart';

final Firestore firestore = Firestore.instance;

class ImageService {
  static Future<String> uploadImgFireStorageFile(
      {File imageFile, String fileName, @required User user}) async {
    var uuid = new Uuid();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('images')
        .child("${uuid.v1()}.jpg");

    var uploadImg = await getCompressImageFile(imageFile);

    final StorageUploadTask uploadTask = firebaseStorageRef.putFile(uploadImg);

    final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;

    final String url = (await downloadUrl.ref.getDownloadURL());

    return url;
  }

  static Future<String> uploadImgFireStorageInt(
      {Asset asset, String fileName}) async {
    var uuid = new Uuid();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('ProductImages')
        .child("${uuid.v1()}.jpg");

    ByteData byteData = await asset.requestOriginal();
    List<int> imageIntData = byteData.buffer.asUint8List();

    List<int> uploadImgInt = await getCompressImageInt(imageIntData);

    var uploadImg = Uint8List.fromList(uploadImgInt);

    final StorageUploadTask uploadTask = firebaseStorageRef.putData(uploadImg);

    final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;

    final String url = await downloadUrl.ref.getDownloadURL();

    return url;
  }

  static Future<List> uploadMultipleImgFireStorageInt(
      {List<Asset> assetList, String fileName}) async {
    List<String> urlList = [];
    try {
      for (var asset in assetList) {
        print(asset);
        var uuid = new Uuid();

        final StorageReference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('ProductImages')
            .child("${uuid.v1()}.jpg");

        ByteData byteData = await asset.requestOriginal();
        List<int> imageIntData = byteData.buffer.asUint8List();

        List<int> uploadImgInt = await getCompressImageInt(imageIntData);

        var uploadImg = Uint8List.fromList(uploadImgInt);

        final StorageUploadTask uploadTask =
            firebaseStorageRef.putData(uploadImg);

        final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;

        final String url = await downloadUrl.ref.getDownloadURL();

        urlList.add(url);
      }
    } catch (e) {
      print(e);
    }

    return urlList;
  }

  static Future<File> getCompressImageFile(File file) async {
    var uuid = new Uuid();
    var dir = await path_provider.getTemporaryDirectory();
    var targetPath = dir.absolute.path + uuid.v1() + '.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      minWidth: 300,
      minHeight: 300,
      rotate: 0,
    );
    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  static Future<List<int>> getCompressImageInt(List<int> list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      quality: 70,
      minWidth: 500,
      minHeight: 500,
      rotate: 0,
    );
    print(list.length);
    print(result.length);
    return result;
  }
}
