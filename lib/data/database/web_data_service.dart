import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import 'package:what_next/models/todo.dart';

import 'data_repository.dart';

class WebDataService extends Repository {
  // Current user's id
  final String userId;

  final CollectionReference todoCollection = fb.firestore().collection('Todos');

  WebDataService({this.userId});

  @override
  Stream<List<Todo>> get todos {
    return todoCollection
        .where(Todo.COLUMN_USER_ID, "==", userId)
        .orderBy(Todo.COLUMN_DATE_CREATED, 'desc')
        .onSnapshot
        .map(_todosFromSnapshot);
  }

  List<Todo> _todosFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((document) => Todo(
              id: document.data()[Todo.COLUMN_ID],
              description: document.data()[Todo.COLUMN_DESCRIPTION],
              isDone: document.data()[Todo.COLUMN_IS_DONE],
              dateCreated: document.data()[Todo.COLUMN_DATE_CREATED],
            ))
        .toList();
  }

  @override
  Future addTodo({String description}) async {
    String todoId = todoCollection.doc().id;
    try {
      return await todoCollection.doc(todoId).set({
        Todo.COLUMN_ID: todoId,
        Todo.COLUMN_USER_ID: userId,
        Todo.COLUMN_DESCRIPTION: description,
        Todo.COLUMN_IS_DONE: false,
        Todo.COLUMN_DATE_CREATED: DateTime.now(),
      });
    } catch (e) {
      print("Failed to add todo: $e");
      return null;
    }
  }

  @override
  void updateTodo(Todo todo) async {
    todoCollection.doc(todo.id).update(data: {
      Todo.COLUMN_ID: todo.id,
      Todo.COLUMN_USER_ID: userId,
      Todo.COLUMN_DESCRIPTION: todo.description,
      Todo.COLUMN_IS_DONE: todo.isDone,
      Todo.COLUMN_DATE_CREATED: todo.dateCreated,
    });
  }

  @override
  void deleteTodo(Todo todo) async {
    await todoCollection.doc(todo.id).delete();
  }
}
