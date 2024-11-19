import 'package:google_sign_in/google_sign_in.dart';
import 'package:rates/services/auth/auth_provider.dart';
import 'package:rates/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as gp
    show GoogleAuthProvider, FirebaseAuth, FirebaseAuthException;
import 'dart:developer' as devtools show log;

class GoogleAuthProvider implements AuthProvider {
  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }

  @override
  AuthUser? get currentUser {
    final user = gp.FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({String? email, String? password}) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    try {
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = gp.GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await gp.FirebaseAuth.instance.signInWithCredential(credential);
        return AuthUser.fromFirebase(gp.FirebaseAuth.instance.currentUser!);
      } else {
        throw Exception('User not logged in');
      }
    } on gp.FirebaseAuthException catch (e) {
      devtools.log('Error: $e');
      throw Exception('Error: $e');
    } catch (e) {
      devtools.log('Error: $e');
      throw Exception('Error: $e');
    }
  }

  @override
  Future<void> logOut() {
    return gp.FirebaseAuth.instance.signOut();
  }
}
