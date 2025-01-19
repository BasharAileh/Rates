import 'package:google_sign_in/google_sign_in.dart';
import 'package:rates/services/auth/auth_provider.dart';
import 'package:rates/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as gp
    show GoogleAuthProvider, FirebaseAuth, FirebaseAuthException;
import 'dart:developer' as devtools show log;
import 'package:rates/services/cloud/firebase_cloud_storage.dart';

class GoogleAuthProvider implements AuthProvider {
  FirebaseCloudStorage cloudService = FirebaseCloudStorage();
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
      AuthUser user;
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = gp.GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await gp.FirebaseAuth.instance.signInWithCredential(credential);
        user = currentUser!;
        Map<String, dynamic> userMap = user.toMap();
        userMap.remove('id');
        await cloudService.insertDocument('user', userMap, id: user.id);
        print('gmail user: $user\ncredential: $credential');
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

  @override
  Future<void> updateProfile({required String displayName}) async {
    final user = gp.FirebaseAuth.instance.currentUser;
    final cloudService = FirebaseCloudStorage();
    if (user != null) {
      await user.updateProfile(displayName: displayName);
      await cloudService.updateUserName(user.uid, displayName);
    }
  }
}
