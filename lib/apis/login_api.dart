import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_bloc_project/models.dart';

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({
    required String email,
    required String password,
  });
}

@immutable
class LoginApi implements LoginApiProtocol {
  // singelton pattern
  // const LoginApi._shareInstance();
  // static const LoginApi _shared = LoginApi._shareInstance();
  // factory LoginApi.instance() => _shared;

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) =>
      // waiting for 2 seconds -> check if elail and password was true -> then isLoggenIn checks previous value was true we create a LoginHandle.fooBar() and return from the login function, else return null
      Future.delayed(
        const Duration(seconds: 2),
        () => email == 'foo@bar.com' && password == 'foobar',
      ).then((isLoggenIn) => isLoggenIn ? const LoginHandle.fooBar() : null);
}
