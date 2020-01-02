import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:what_next/data/datasource/data_source.dart';
import 'package:what_next/data/database/data_repository.dart';
import 'package:what_next/models/todo.dart';
import 'package:what_next/models/user.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final Repository dataService = DataSource.getRepo(userId: user.id);

    final todos = Provider.of<List<Todo>>(context);

    if (todos == null || todos.isEmpty) {
      return Center(
        child: Text(
          'You don\'t have any To-dos',
          style: TextStyle(fontSize: 20.0),
        ),
      );
    } else {
      return ListView.separated(
          itemCount: todos.length,
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.blueGrey,
              height: 0.0,
              // Increase thickness for the web so it is visible.
              thickness: kIsWeb ? 1.0 : 0.0,
            );
          },
          itemBuilder: (context, index) {
            Todo todo = todos[index];
            return ListTile(
              leading: Checkbox(
                value: todo.isDone,
                onChanged: (bool value) {
                  setState(() {
                    todo.isDone = value;
                  });
                  dataService.updateTodo(todo);
                },
              ),
              title: Text(
                todo.description,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              subtitle: Text(
                DateFormat.yMMMMEEEEd().format(todo.dateCreated),
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 24.0,
                  semanticLabel: 'Delete Todo',
                ),
                onPressed: () {
                  dataService.deleteTodo(todo);
                },
              ),
            );
          });
    }
  }
}
