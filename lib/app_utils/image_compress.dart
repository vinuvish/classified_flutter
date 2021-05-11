import 'dart:async';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:uuid/uuid.dart';

class ImageCompress {
  static Future<File> getCompressImageFile(File file) async {
    var uuid = new Uuid();
    var dir = await path_provider.getTemporaryDirectory();
    var targetPath = dir.absolute.path + uuid.v1() + '.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      minWidth: 500,
      minHeight: 500,
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
      minWidth: 300,
      minHeight: 300,
      rotate: 0,
    );
    print(list.length);
    print(result.length);
    return result;
  }
}
