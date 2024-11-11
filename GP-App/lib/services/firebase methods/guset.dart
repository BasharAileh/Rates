import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Anonymous Sign-In
  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      devtools.log(e.toString());
      return null;
    }
  }
}
