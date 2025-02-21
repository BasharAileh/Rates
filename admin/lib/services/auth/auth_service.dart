import 'package:admin/services/auth/firebase_auth_provider.dart';

import 'auth_provider.dart';
import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String userName,
  }) =>
      provider.createUser(
        email: email,
        password: password,
        userName: userName,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    String? email,
    String? password,
  }) {
    return provider.logIn(
      email: email!,
      password: password!,
    );
  }

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<void> logInAnonymously() => provider.logInAnonymously();

  @override
  Future<void> updateUserName({required String displayName}) async {
    provider.updateUserName(displayName: displayName);
  }
}
