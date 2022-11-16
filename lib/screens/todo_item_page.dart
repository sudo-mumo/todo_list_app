import 'package:flutter/material.dart';
import '../screens/loading.dart';

import '../model/todo.dart';
import '../services/database_services.dart';

class TodoItemPage extends StatefulWidget {
  const TodoItemPage({super.key, required this.title});

  final String title;

  @override
  State<TodoItemPage> createState() => _TodoItemPage();
}

class _TodoItemPage extends State<TodoItemPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        // leading: const Icon(Icons.menu),
        title: Text(widget.title),
        centerTitle: true,
        // actions: const [
        //   Padding(
        //     padding: EdgeInsets.all(12.0),
        //     child: Icon(Icons.settings),
        //   )
        // ],
      ),
      body: StreamBuilder<List<Todo>?>(
        stream: DatabaseService().listTodos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Loading();
          }
          List<Todo>? todos = snapshot.data;

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListView.builder(
              itemCount: todos?.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  direction: DismissDirection.horizontal,
                  key: UniqueKey(),
                  background: Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      DatabaseService().deleteTask(todos[index].uid);
                    });
                  },
                  child: Card(
                    // color: Colors.white24,
                    child: ListTile(
                      onTap: () {
                        if (todos[index].isComplete != true) {
                          setState(() {
                            DatabaseService().completeTask(todos[index].uid);
                          });
                        } else {
                          setState(() {
                            DatabaseService().notcompleteTask(todos[index].uid);
                          });
                        }
                      },
                      leading: todos![index].isComplete
                          ? const Icon(
                              Icons.album,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.album,
                              color: Colors.red,
                            ),
                      title: Text(todos[index].title),
                      // subtitle: const Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  contentPadding: const EdgeInsets.all(12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text(
                    'New Task',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  children: [
                    Divider(
                      color: Theme.of(context).primaryColor,
                      height: 8,
                      thickness: 1,
                    ),
                    TextFormField(
                      autofocus: true,
                      controller: _textEditingController,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.5,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Eg. Go out shopping",
                        border: InputBorder.none,
                      ),
                      enabled: true,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 24,
                    ),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_textEditingController.text.isNotEmpty) {
                            await DatabaseService().createNewTodo(
                                _textEditingController.text.trim());
                            _textEditingController.text = '';
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                        ),
                        child: const Text(
                          'Add Task',
                          style: TextStyle(
                            // height: 1.5,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              });
        },
        tooltip: 'Add ToDo',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
