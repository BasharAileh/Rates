import 'auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    String? email,
    String? password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String userName,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> initialize();

  void updateUserName({required String displayName});
}
