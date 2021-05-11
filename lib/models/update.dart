import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class Update {
  var appBuildNumberLocal;
  var appBuildNumberServer;
  bool isUpdateMandatory;

  Update(
      {this.appBuildNumberLocal,
      this.isUpdateMandatory,
      this.appBuildNumberServer});

  factory Update.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    final settings = Hive.box('settings');

    num appBuildNumber = int.tryParse(settings.get('appBuildNumber'));

    return Update(
        appBuildNumberServer: data['appBuildNumberServer'] ?? 0,
        isUpdateMandatory: data['isUpdateMandatory'] ?? false,
        appBuildNumberLocal: appBuildNumber);
  }
}
