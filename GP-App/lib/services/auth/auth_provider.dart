import 'auth_user.dart';

abstract class AuthProvider {
  AuthUser? get user;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> register({
    required String email,
    required String password,
  });
}
