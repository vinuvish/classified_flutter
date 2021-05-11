import 'package:classified_flutter/app_utils/time_parse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chats {
  String id;
  String documentId;
  DateTime timestampUpdeted;
  String timestampUpdetedStr;
  List uuids;
  List<Messages> messages;
  Messages message;
  String senderName;
  String senderUuid;
  String reciverName;
  String reciverUuid;
  String productId;
  String productTitle;
  String productLocation;
  bool productIsSold;
  String productImgUrl;

  Chats({
    this.id,
    this.documentId,
    this.timestampUpdeted,
    this.timestampUpdetedStr,
    this.uuids,
    this.messages,
    this.message,
    this.senderName,
    this.reciverName,
    this.senderUuid,
    this.reciverUuid,
    this.productId,
    this.productTitle,
    this.productLocation,
    this.productImgUrl,
    this.productIsSold,
  });

  factory Chats.fromFirestore(DocumentSnapshot document) {
    Map data = document.data;
    if (data == null) return null;
    return Chats(
        id: document.documentID,
        documentId: document.documentID,
        timestampUpdeted: TimeParse.parseTime(data['timestampUpdeted']),
        timestampUpdetedStr:
            TimeParse.formatTimeToString(data['timestampUpdeted']),
        uuids: data['uuids'] ?? [],
        senderName: data['senderName'] ?? '',
        reciverName: data['reciverName'] ?? '',
        productId: data['productId'] ?? '',
        productTitle: data['productTitle'] ?? '',
        productLocation: data['productLocation'] ?? '',
        productIsSold: data['productIsSold'] ?? '',
        productImgUrl: data['productImgUrl'] ?? '',
        senderUuid: data['senderUuid'] ?? '',
        reciverUuid: data['reciverUuid'] ?? '',
        messages: getMessages(data['messages'] ?? {}) ?? {});
  }
  static List<Messages> getMessages(dynamic data) {
    List<Messages> messages = [];
    if (data != {}) {
      data.forEach((k, v) {
        Messages msg = Messages.fromMap(v);
        messages.add(msg);
      });
    }
    return messages;
  }
}

class Messages {
  String id;
  DateTime timestampAdded;
  String message;
  String uuid;
  bool isReaded;

  Messages(
      {this.id, this.timestampAdded, this.message, this.uuid, this.isReaded});
  factory Messages.fromMap(Map<dynamic, dynamic> data) {
    if (data.isEmpty) return null;

    return Messages(
        id: data['id'] ?? '',
        timestampAdded: TimeParse.parseTime(data['timestampAdded']),
        message: data['message'] ?? '',
        uuid: data['uuid'] ?? '',
        isReaded: data['isReaded'] ?? false);
  }
}
