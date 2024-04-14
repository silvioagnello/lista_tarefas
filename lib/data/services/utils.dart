import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:lista_tarefas/data/services/prefs.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class Utils {
  late List todoList = [];

  Future<File> _getFile() async {
    const nameFile = 'data.json';
    File checkFile = File('');

    final directory = await path_provider.getApplicationDocumentsDirectory();

    checkFile = File('${directory.path}/$nameFile');

    bool fileExists = await checkFile.exists();
    if (fileExists) {
      return checkFile;
    }

    //TRATAMENTO PARA NÃO RETORNAR NULO
    Map<String, dynamic> task = {};
    task['title'] = 'teste';
    task['ok'] = false;
    todoList.add(task);
    String data = jsonEncode(todoList);
    if (!kIsWeb) {
      checkFile.writeAsString(data);
    }

    return checkFile;
  }

  // Future<File>
  saveData(table) async {
    if (table != null) {
      String data = jsonEncode(table);
      if (!kIsWeb) {
        final file = await _getFile();
        file.writeAsString(data);
        // return file.writeAsString(data);
      } else {
        const nameFile = 'data.json';
        Prefs.setString(nameFile, data);
      }
    }

    //TRATAMENTO PARA NÃO RETORNAR NULO
    // Map<String, dynamic> task = {};
    // task['title'] = 'teste';
    // task['ok'] = false;
    // todoList.add(task);
    // String data = jsonEncode(todoList);
    // final file = await _getFile();
    // //return file.writeAsString(data);
    //file.writeAsString(data);
  }

  Future<String> readData() async {
    try {
      if (kIsWeb) {
        const nameFile = 'data.json';
        String data = (await Prefs.getString(nameFile));
        return data;
      }
      final file = await _getFile();
      return file.readAsString();
    } on Exception catch (e) {
      return e.toString();
      //return null;
    }
  }
}
