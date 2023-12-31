import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileStorage {
  final filename = "participants";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$filename.txt');
  }

  Future<String> readFileAsString() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return "Read error: $e";
    }
  }

  Future<File> writeFile(String content) async {
    final file = await _localFile;
    return file.writeAsString(content);
  }
}