import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:what_next/models/user.dart';

import 'base_auth_service.dart';

class AuthService extends BaseAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'profile',
      'openid',
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with Google
  @override
  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final FirebaseUser user =
          (await _auth.signInWithCredential(authCredential)).user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      return Future.error("Error signing in with google: $e");
    }
  }

  // Convert FirebaseUser to our User object model
  User _userFromFirebaseUser(FirebaseUser firebaseUser) {
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
    if (_auth.currentUser() == null) {
      return null;
    }
    return _auth.onAuthStateChanged.map(
        (FirebaseUser firebaseUser) => _userFromFirebaseUser(firebaseUser));
  }

  @override
  Future signOut() async {
    _auth.signOut();
  }
}
