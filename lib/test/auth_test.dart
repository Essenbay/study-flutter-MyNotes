import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynote/services/auth/auth_exeptions.dart';
import 'package:mynote/services/auth/auth_provider.dart';
import 'package:mynote/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialiazed, false);
    });
    test('Cannot log out if not initialized', () {
      expect(provider.logout(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });
    test('Should be able to be initialized', () async {
      await provider.initializeApp();
      expect(provider._isInitialized, true);
    });
    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });
    test('Should be able to initialize in less than 2 seocnds', () async {
      await provider.initializeApp();
      expect(provider.isInitialiazed, true);
    }, timeout: const Timeout(Duration(seconds: 2)));
    test('Create user should delegate to logIn function', () async {
      final wrongEmailUser =
          provider.createUser(email: 'foo@bar.com', password: 'anypassword');
      expect(wrongEmailUser, throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final occupiedEmailUser = provider.createUser(
          email: 'alreadyinuse@bar.com', password: 'anypassword');
      expect(occupiedEmailUser,
          throwsA(const TypeMatcher<EmailAlreadyInUseAuthException>()));
      final badPassword =
          provider.createUser(email: 'anyemail@bar.com', password: 'foobar');
      expect(badPassword, throwsA(const TypeMatcher<WrongPasswordAuthException>()));
      final user = await provider.createUser(
          email: 'anyemail@bar.com', password: 'anypassword');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('LogIn user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('Should be able to log out and log in  ', () async {
      await provider.logout();
      await provider.login(email: 'anyemail@baz.com', password: 'anypassword');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialiazed => _isInitialized;

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitialiazed) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initializeApp() async {
    if (!isInitialiazed) {
      await Future.delayed(const Duration(seconds: 1));
      _isInitialized = true;
    }
  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    if (!_isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (email == 'alreadyinuse@bar.com') throw EmailAlreadyInUseAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(email: 'foo@bar.com ', isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialiazed) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(email: 'foo@bar.com', isEmailVerified: true);
    _user = newUser;
  }
}
