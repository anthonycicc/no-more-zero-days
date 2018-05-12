import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileLoader {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return new File('$path/days.json');
  }

  Future<File> writeFile(String data) async {
    final file = await _localFile;

    return file.writeAsString(data);
  }

  Future<String> readFile() async {
    try {
      final file = await _localFile;

      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      throw OSError("File not found");
    }
  }

}