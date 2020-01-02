import 'package:flutter/material.dart';
import 'package:what_next/auth/auth_service.dart';
import 'package:what_next/auth/base_auth_service.dart';
import 'package:what_next/models/user.dart';
import 'package:what_next/shared/loading.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final BaseAuthService _authService = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.teal,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Sign in to continue with \'What Next?\'',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 36.0,
              ),
              FittedBox(
                fit: BoxFit.contain, // otherwise the logo will be tiny
                child: Builder(
                    builder: (context) =>
                        loading ? Loading() : _signInButton(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton(BuildContext context) {
    return RaisedButton(
      color: Colors.red,
      child: Text(
        'Sign in with Google',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        setState(() => loading = true);
        await _authService.signInWithGoogle().then((User user) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Welcome ${user.email}"),
            ),
          );
          print("Welcome ${user.email.toString()}");
        }).catchError((e) {
          setState(() => loading = false);
          print(e.toString());
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        });
      },
    );
  }
}
