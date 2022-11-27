import 'package:firebase_core/firebase_core.dart';
import 'package:mynote/services/auth/auth_user.dart';
abstract class AuthProvider{
  AuthUser? get currentUser;
  Future<void> initializeApp();
  Future<AuthUser> login({
      required String email,
      required String password
    }
  );
  Future<AuthUser> createUser({
      required String email,
      required String password
  });
  Future<void> logout();
  Future<void> sendEmailVerification();
}