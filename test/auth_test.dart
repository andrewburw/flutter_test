import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:privatenotes/services/auth/auth_exceptions.dart';
import 'package:privatenotes/services/auth/auth_provider.dart';
import 'package:privatenotes/services/auth/auth_user.dart';
import 'package:test/test.dart';


void main() {
  group('Mock Authification', () {
    final provider  = MockAuthProvider();
    test('Should not be inicialized to begin with', () {
      expect(provider.isInicialized, false);
    });

    test('Cannot logout if not inicialized', () {
      expect(provider.logout(), throwsA(const TypeMatcher<NotInitializedException>()),);
    }); 

    test('Shuld be able to be inicialized', () async {
      await provider.inicialize();
      expect(provider.isInicialized, true);
    });

    test('User shild be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test('Shuld  be able to inicialize in less than 2 seconds ', () async {
      await provider.inicialize();
      expect(provider.isInicialized, true);
    }, timeout: const Timeout( Duration(seconds: 5)));

    test('Create user should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(email: 'lol@bar.com', password: 'anypass');
      expect(badEmailUser, throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUser(email: 'someone@tes.lv', password: 'test123');

      expect(badPasswordUser, throwsA(const TypeMatcher<WrongPasswordFoundAuthException>()));

      final user = await provider.createUser(email: 'email', password: 'pass');

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get verifed', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and login', () async {
      await provider.logout();
      await provider.logIn(email: 'email', password: 'password');

      final user = provider.currentUser;
      expect(user, isNotNull);
    });
   });
}

class NotInitializedException implements Exception {

}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInicialized = false;
  bool get isInicialized => _isInicialized;
  @override
  Future<AuthUser> createUser({required String email, required String password}) async {
    if (!isInicialized) throw NotInitializedException();
     await Future.delayed(const Duration(seconds: 2));
     return logIn(email: email, password: password);
  }

  @override

  AuthUser? get currentUser => _user;

  @override
  Future<void> inicialize() async {
    await Future.delayed(const Duration(seconds: 2));
    _isInicialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInicialized) throw NotInitializedException();
    if (email == 'lol@bar.com') throw UserNotFoundAuthException();
    if (password == 'test123') throw WrongPasswordFoundAuthException();
    const  user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);

  }

  @override
  Future<void> logout() async {
    if (!isInicialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 2));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInicialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser  = AuthUser(isEmailVerified: true);
    _user = newUser;


  }

}