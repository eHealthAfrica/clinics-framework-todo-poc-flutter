import 'package:what_next/models/todo.dart';

abstract class Repository {
  Stream<List<Todo>> get todos;

  Future addTodo({String description});

  void updateTodo(Todo todo);

  void deleteTodo(Todo todo);
}
