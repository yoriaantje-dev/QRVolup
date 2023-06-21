import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

String fileName = "qrStorage";

class FileHelper {
  Future<String> get _turfStoragePath async {
    final Directory dir = await getApplicationDocumentsDirectory();
    String fullPath = join(dir.path, fileName);
    Directory turfDirectory = Directory(fullPath);
    if (!turfDirectory.existsSync()) {
      await turfDirectory.create();
    }
    return fullPath;
  }

  Future<List<File>> getFiles() async {
    final String dirPath = await _turfStoragePath;
    List<File> files = [];
    List<FileSystemEntity> fse = Directory(dirPath).listSync();
    for (var element in fse) {
      if (element is File) {
        files.add(element);
      }
    }
    return files;
  }

  Future writeToFile(String fileName, String content) async{
    final String dirPath = await _turfStoragePath;
    final String filePath = join(dirPath, fileName);
    File file = File(filePath);
    return file.writeAsString(content);
  }

  Future<String> readFromFile (File file) async {
    String content = await file.readAsString();
    return content;
  }

  Future deleteFile (File file) async {
    await file.delete();
  }
}