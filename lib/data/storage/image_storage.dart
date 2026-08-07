import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalImageStorage {
  Future<String> saveImage(File image) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final saved = await image.copy(path);
    return saved.path;
  }
}
