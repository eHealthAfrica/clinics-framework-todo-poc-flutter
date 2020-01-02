import 'package:what_next/models/user.dart';

abstract class BaseAuthService {
  Future<User> signInWithGoogle();
  Future signOut();
  Stream<User> get user;
}