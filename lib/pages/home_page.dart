import 'package:flutter/material.dart';
import 'package:lista_tarefas/data/models/task_model.dart';
import 'package:lista_tarefas/data/repositories/repository_tasks.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RepositoryTasks _repositoryTasks = RepositoryTasks();
  final todoController = TextEditingController();
  late Tarefa _lastRemoved;
  String? errorTxt;
  late int _lastRemovedPos;

  List<Tarefa> _todoList = [];

  @override
  void initState() {
    super.initState();
    _initialization2();
  }

  _initialization2() {
    RepositoryTasks repository = context.read<RepositoryTasks>();
    repository.getTasks();
    _todoList = repository.todoList;
  }

  @override
  Widget build(BuildContext context) {
    RepositoryTasks repositoryTasks = context.watch<RepositoryTasks>();
    _todoList = repositoryTasks.todoList;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
                      controller: todoController,
                      decoration: InputDecoration(
                        labelText: 'Nova Tarefa',
                        labelStyle: const TextStyle(
                          backgroundColor: Colors.white,
                          color: Colors.blueAccent,
                        ),
                        errorText: errorTxt,
                      ),
                    ),
                  ),
                ),
                Consumer<RepositoryTasks>(
                    builder: (context, repositoryTasks, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent),
                    onPressed: () {
                      if (todoController.text.isEmpty) {
                        setState(() {
                          errorTxt = 'Deve digitar um texto';
                        });
                      } else {
                        repositoryTasks.addTask(todoController.text);
                        _todoList = repositoryTasks.todoList;
                        todoController.text = '';
                        errorTxt = '';
                      }
                    },
                    child: const Text('ADD'),
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _todoList.length,
              itemBuilder: buildItem,
            ),
          )
        ],
      ),
    );
  }

  Widget? buildItem(context, index) {
    Tarefa task = _todoList[index];
    return Consumer<RepositoryTasks>(builder: (context, repository, child) {
      return Dismissible(
        background: Container(
          color: Colors.red,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(18.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ],
          ),
        ),
        direction: DismissDirection.startToEnd,
        key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
        onDismissed: (direction) {
          _lastRemoved = task;
          _lastRemovedPos = index;

          repository.delTask(index);

          SnackBar snackBar = SnackBar(
            content: const Text(
              'Tarefa foi removida',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.grey,
            action: SnackBarAction(
                label: 'Desfazer',
                textColor: Colors.red,
                onPressed: () {
                  repository.insTask(_lastRemovedPos, _lastRemoved);
                  //setState(() {
                  _todoList = repository.todoList;
                  //});
                }),
            duration: const Duration(seconds: 10),
          );
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            snackBar,
          );
        },
        child: CheckboxListTile(
          title: Text(task.title as String),
          secondary:
              CircleAvatar(child: Icon(task.ok! ? Icons.check : Icons.error)),
          value: task.ok,
          onChanged: (c) {
            setState(() {
              task.ok = c;
            });
            repository.saveData();
          },
        ),
      );
    });
  }
}
