import 'package:firebase/firebase.dart' as fb;
import 'package:what_next/models/user.dart';

import 'base_auth_service.dart';

class AuthServiceWeb extends BaseAuthService {
  final fb.Auth _auth = fb.auth();

  // Sign in with Google
  @override
  Future<User> signInWithGoogle() async {
    try {
      fb.UserCredential _userCredential =
          await _auth.signInWithPopup(fb.GoogleAuthProvider());

      return User(
          id: _userCredential.user.uid,
          email: _userCredential.user.email,
          displayName: _userCredential.user.displayName);
    } catch (e) {
      return Future.error("Error signing in with google: $e");
    }
  }

  // Convert FirebaseUser to our User object model
  User _userFromFirebaseUser(fb.User firebaseUser) {
    return firebaseUser != null
        ? User(
            id: firebaseUser.uid,
            email: firebaseUser.email,
            displayName: firebaseUser.displayName)
        : null;
  }

  // Auth change stream notifier
  @override
  Stream<User> get user {
    if (_auth.currentUser == null) {
      return null;
    }
    return _auth.onAuthStateChanged
        .map((fb.User firebaseUser) => _userFromFirebaseUser(firebaseUser));
  }

  @override
  Future signOut() async {
    _auth.signOut();
  }
}
