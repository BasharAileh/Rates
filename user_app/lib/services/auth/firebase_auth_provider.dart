import 'package:firebase_core/firebase_core.dart';
import 'package:rates/firebase_options.dart';
import 'package:rates/services/auth/auth_exception.dart';
import 'package:rates/services/auth/auth_provider.dart';
import 'package:rates/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:rates/services/cloud/firebase_cloud_storage.dart';

class FirebaseAuthProvider implements AuthProvider {
  FirebaseCloudStorage cloudService = FirebaseCloudStorage();
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var user = currentUser;
      if (user != null) {
        userName = userName.trim();
        if (userName.contains(' ')) {
          // If the username has more than one word
          userName =
              '${userName.split(' ').first[0].toUpperCase()}${userName.split(' ').first.substring(1)} '
              '${userName.split(' ').last[0].toUpperCase()}${userName.split(' ').last.substring(1)}';
        } else {
          // If the username is a single word
          userName =
              '${userName[0].toUpperCase()}${userName.substring(1).toLowerCase()}';
        }

        await FirebaseAuth.instance.currentUser!
            .updateProfile(displayName: userName);
        await FirebaseAuth.instance.currentUser!.updatePhotoURL(
            'assets/images/profile_images/default_profile_image_1.png');
        user = currentUser!;
        Map<String, dynamic> userMap = user.toMap();
        userMap.remove('id');
        userMap['ratings'] = {
          'a01': 0,
        };
        await cloudService.insertDocument('user', userMap, id: user.id);
        return user;
      } else {
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<AuthUser> logIn({
    String? email,
    String? password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'wrong-password') {
        throw InvalidCredentialAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        await user.sendEmailVerification();
      } else {
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        throw TooManyRequestsAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.isAnonymous) {
        return AuthUser.fromAnonymous(user);
      }
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<AuthUser?> logInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException();
      }
    } catch (e) {
      print(e);
      throw GenericAuthException();
    }
  }

  Future<void> changeDisplayName(String displayName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateProfile(displayName: displayName);
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> updateUserName({required String displayName}) async {
    final user = FirebaseAuth.instance.currentUser;
    final cloudService = FirebaseCloudStorage();
    if (user != null) {
      await user.updateProfile(displayName: displayName);
      await cloudService.updateUserName(user.uid, displayName);
    } else {
      throw UserNotLoggedInException();
    }
  }
}
