import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_next/auth/auth_service.dart';
import 'package:what_next/models/user.dart';
import 'package:what_next/wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: /*kIsWeb ? AuthServiceWeb().user :*/ AuthService().user,
      catchError: (_, __) => null,
      child: MaterialApp(
        title: 'What Next?',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.red,
        ),
        home: Wrapper(),
      ),
    );
  }
}
