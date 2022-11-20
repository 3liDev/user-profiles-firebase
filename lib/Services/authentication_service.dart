import 'package:firebase_auth/firebase_auth.dart';

import '../DatabaseManager/database_manager.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
// registration with email and password

  Future createNewUser(String name, String email, String password) async {
    try {
      // AuthResult result = await _auth.createUserWithEmailAndPassword(
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // FirebaseUser user = result.user;
      User? user = result.user;
      await DatabaseManager().createUserData(name, 'Male', 100, user!.uid);

      return user;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

// sign with email and password

  Future loginUser(String email, String password) async {
    try {
      // AuthResult result = await _auth.signInWithEmailAndPassword(
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

// signout

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (error) {
      // ignore: avoid_print
      print(error.toString());
      return null;
    }
  }
}
