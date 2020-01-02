import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_next/auth/auth_screen.dart';

import 'home/home_screen.dart';
import 'models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get Streamed user object
    final user = Provider.of<User>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
