import 'package:rates/services/auth/firebase_auth_provider.dart';
import 'package:rates/services/auth/google_auth_provider.dart';
import 'auth_provider.dart';
import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());
  factory AuthService.google() => AuthService(GoogleAuthProvider());

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
    switch (provider.runtimeType) {
      case const (FirebaseAuthProvider):
        return (provider as FirebaseAuthProvider).logIn(
          email: email!,
          password: password!,
        );
      case const (GoogleAuthProvider):
        return (provider as GoogleAuthProvider).logIn();
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();

  Future<AuthUser> logInAnonymously() =>
      (provider as FirebaseAuthProvider).logInAnonymously();

  @override
  Future<void> updateUserName({required String displayName}) async {
    provider.updateUserName(displayName: displayName);
  }
}
