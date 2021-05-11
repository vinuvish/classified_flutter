import 'package:classified_flutter/components/z_bot_toast.dart';
import 'package:classified_flutter/models/chats.dart';
import 'package:classified_flutter/models/product.dart';
import 'package:classified_flutter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

final Firestore _firestore = Firestore.instance;

class ChatService {
  static Future<Stream<List<Chats>>> streamChats({User user}) async {
    var ref = _firestore
        .collection('chats')
        .where('uuids', arrayContains: user.id)
        .orderBy('timestampUpdeted', descending: true)
        .snapshots()
        .asBroadcastStream();

    return ref.map((list) =>
        list.documents.map((doc) => Chats.fromFirestore(doc)).toList());
  }

  static Future sendChatMessage(
      {Chats chats, Product product, User user}) async {
    try {
      var uuid = Uuid();
      String chatUUID = uuid.v4();
      QuerySnapshot doc = await _firestore
          .collection('chats')
          .where('senderUuid', isEqualTo: user.id)
          .where('reciverUuid', isEqualTo: product.user.id)
          .where('productId', isEqualTo: product.id)
          .limit(1)
          .getDocuments();

      if (doc.documents.isNotEmpty) {
        chats.documentId = doc.documents[0].documentID;
      }

      await _firestore.collection('chats').document(chats.documentId).setData({
        'messages': {
          chatUUID: {
            'id': chatUUID,
            'uuid': chats.message.uuid,
            'message': chats.message.message,
            'timestampAdded': DateTime.now(),
            'isReaded': false
          }
        },
        'senderName': chats.senderName,
        'reciverName': chats.reciverName,
        'senderUuid': chats.senderUuid,
        'reciverUuid': chats.reciverUuid,
        'productId': chats.productId,
        'productTitle': chats.productTitle,
        'productLocation': chats.productLocation,
        'productIsSold': chats.productIsSold,
        'productImgUrl': chats.productImgUrl,
        'uuids': chats.uuids,
        'timestampUpdeted': DateTime.now(),
      }, merge: true);
      ZBotToast.showToastSuccess(message: 'Messege sent');
    } catch (e) {
      ZBotToast.showToastSomethingWentWrong();
      print(e);
    }
  }

  static Future sendRealTimeChat({Chats chats, Messages message}) async {
    var uuid = Uuid();
    String chatUUID = uuid.v4();

    try {
      await _firestore.collection('chats').document(chats.documentId).setData({
        'messages': {
          chatUUID: {
            'id': chatUUID,
            'uuid': message.uuid,
            'message': message.message,
            'timestampAdded': DateTime.now(),
            'isReaded': false
          }
        },
        'timestampUpdeted': DateTime.now(),
      }, merge: true);
    } catch (e) {
      print(e);
    }
  }

  static Future changeChatIsReded({Chats chats}) async {
    try {
      await _firestore.collection('chats').document(chats.documentId).setData({
        'messages': {
          chats.messages[0].id: {'isReaded': true}
        },
        'timestampUpdeted': DateTime.now(),
        'isReaded': true
      }, merge: true);
    } catch (e) {
      print(e);
    }
  }
}
