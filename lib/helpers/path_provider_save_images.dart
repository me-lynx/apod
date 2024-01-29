import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<File> downloadAndSaveImage(String url, String filename) async {
  var directory = await getApplicationDocumentsDirectory();
  var filePath = '${directory.path}/$filename';
  var file = File(filePath);

  if (await file.exists()) {
    return file;
  } else {
    var dio = Dio();
    await dio.download(url, filePath);
    return file;
  }
}

Future<String> getFilePath(String filename) async {
  var directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/$filename';
}
