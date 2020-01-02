import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_next/auth/auth_service.dart';
import 'package:what_next/data/datasource/data_source.dart';
import 'package:what_next/data/database/data_repository.dart';
import 'package:what_next/home/todo_list.dart';
import 'package:what_next/models/todo.dart';
import 'package:what_next/models/user.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final newTodoDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final Repository dataService = DataSource.getRepo(userId: user.id);

    return StreamProvider<List<Todo>>.value(
      value: dataService.todos,
      catchError: (_, e) {
        print("Errored ${e.toString()}");
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("${user.email}"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                _auth.signOut();
              },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            TodoList(),
            Positioned(
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
              child: Row(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: () async {
                      if (newTodoDescriptionController.text.trim().isNotEmpty) {
                        dataService.addTodo(
                            description: newTodoDescriptionController.text);
                        newTodoDescriptionController.clear();
                      }
                    },
                    child: Icon(Icons.add),
                  ),
                  Expanded(
                      child: Card(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 20.0),
                        child: TextFormField(
                          controller: newTodoDescriptionController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Add Todo",
                          ),
                        )),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    newTodoDescriptionController.dispose();
    super.dispose();
  }
}
