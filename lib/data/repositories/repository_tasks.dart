import 'package:flutter/cupertino.dart';
import 'package:lista_tarefas/data/services/utils.dart';
import 'dart:convert';
import 'package:lista_tarefas/data/models/task_model.dart';

class RepositoryTasks extends ChangeNotifier {
  Utils utils = Utils();

  List<Tarefa> todoList = <Tarefa>[];

  void addTask(String text) {
    Tarefa task = Tarefa();
    task.title = text;
    task.ok = false;
    todoList.add(task);
    saveData();
    notifyListeners();
  }

  dynamic saveData() => utils.saveData(todoList);

  getTasks() async {
    String data = await utils.readData();
    if (data != '') {
      final List jsonDecoded = jsonDecode(data) as List;
      todoList = jsonDecoded.map((e) => Tarefa.fromJson(e)).toList();

      if (todoList.length == 1) {
        if (todoList[0].title == 'teste') {
          if (todoList[0].ok == false) {
            todoList.removeAt(0);
          }
        }
      }
      //return todoList;
      notifyListeners();
    }
  }

  insTask(int idx, Tarefa element) {
    todoList.insert(idx, element);
    saveData();
    notifyListeners();
  }

  void delTask(index) {
    todoList.removeAt(index);
    saveData();
    notifyListeners();
  }
}
