import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_app/model/todo.dart';

class DatabaseService {
  CollectionReference todosCollection =
      FirebaseFirestore.instance.collection('Todos');

  Future createNewTodo(String title) async {
    return await todosCollection.add({
      'title': title,
      'isComplete': false,
    });
  }

  Future completeTask(uid) async {
    return await todosCollection.doc(uid).update({
      'isComplete': true,
    });
  }

  Future notcompleteTask(uid) async {
    return await todosCollection.doc(uid).update({
      'isComplete': false,
    });
  }

  Future deleteTask(uid) async {
    await todosCollection.doc(uid).delete();
    return listTodos();
  }

  List<Todo>? todoFromFirestore(QuerySnapshot snapshot) {
    // ignore: unnecessary_null_comparison
    if (snapshot != null) {
      return snapshot.docs.map((e) {
        return Todo(
          title: e.get("title"),
          isComplete: e.get("isComplete"),
          uid: e.id,
        );
      }).toList();
    } else {
      return null;
    }
  }

  Stream<List<Todo>?> listTodos() {
    return todosCollection.snapshots().map(todoFromFirestore);
  }
}
