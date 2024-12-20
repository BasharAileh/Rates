import 'package:flutter_test/flutter_test.dart';
import 'package:rates/services/auth/auth_exception.dart';
import 'package:rates/services/auth/auth_provider.dart';
import 'package:rates/services/auth/auth_user.dart';

void main() {
  group('MockAuthProvider', () {
    final provider = MockAuthProvider();
    test('should not be initialized', () {
      expect(provider.isInitialized, false);
    });
    test('can not log out before isInitialized', () {
      expect(provider.logOut(), throwsA(const TypeMatcher<NotInitialized>()));
    });
    test('should initialize', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test('user should be null after initialize', () {
      expect(provider.currentUser, null);
    });
    test('should be able to initialize in less than 2 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));
    test('Create user should delegate to login function', () async {
      final badEmailUser =
          provider.createUser(email: 'braa@gmail.com', password: 'anyPassword');
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPasswordUser =
          provider.createUser(email: 'any', password: '123456');
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));
      final user =
          await provider.createUser(email: 'email', password: ' password');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('logged in users should be able to get verified ', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('should be able to log out and login again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: ' password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
    test('should be able to log out', () async {
      await provider.logOut();
      expect(provider.currentUser, null);
    });
    test('should not be able to log out if not logged in', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<UserNotLoggedInException>()));
    });
  });
}

class NotInitialized implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitialized();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    String? email,
    String? password,
  }) {
    if (!isInitialized) throw NotInitialized();
    if (email == 'braa@gmail.com') throw UserNotFoundAuthException();
    if (password == '123456') throw WrongPasswordAuthException();
    const user = AuthUser(
      email: '',
      isEmailVerified: false,
      isAnonymous: false,
      id: '',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitialized();
    if (_user == null) {
      throw UserNotLoggedInException();
    } else {
      await Future.delayed(const Duration(seconds: 1));
      _user = null;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitialized();
    final user = _user;
    if (user == null) throw UserNotLoggedInException();
    const newuser = AuthUser(
      email: '',
      isEmailVerified: true,
      isAnonymous: false,
      id: '',
    );
    _user = newuser;
  }
}
