import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:what_next/models/todo.dart';

import 'data_repository.dart';

class MobileDataService extends Repository {
  // Current user's id
  final String userId;

  final CollectionReference todoCollection =
      Firestore.instance.collection('Todos');

  MobileDataService({this.userId});

  @override
  Stream<List<Todo>> get todos {
    return todoCollection
        .where(Todo.COLUMN_USER_ID, isEqualTo: userId)
        .orderBy(Todo.COLUMN_DATE_CREATED, descending: true)
        .snapshots()
        .map(_todosFromSnapshot);
  }

  List<Todo> _todosFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((document) => Todo(
              id: document.data[Todo.COLUMN_ID],
              description: document.data[Todo.COLUMN_DESCRIPTION],
              isDone: document.data[Todo.COLUMN_IS_DONE],
              dateCreated:
                  (document.data[Todo.COLUMN_DATE_CREATED] as Timestamp)
                      .toDate(),
            ))
        .toList();
  }

  @override
  Future addTodo({String description}) async {
    String todoId = todoCollection.document().documentID;
    try {
      return await todoCollection.document(todoId).setData({
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
    todoCollection.document(todo.id).updateData({
      Todo.COLUMN_ID: todo.id,
      Todo.COLUMN_USER_ID: userId,
      Todo.COLUMN_DESCRIPTION: todo.description,
      Todo.COLUMN_IS_DONE: todo.isDone,
      Todo.COLUMN_DATE_CREATED: todo.dateCreated,
    });
  }

  @override
  void deleteTodo(Todo todo) async {
    todoCollection.document(todo.id).delete();
  }
}
