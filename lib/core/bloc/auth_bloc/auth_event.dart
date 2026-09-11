part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class CheckForPreference extends AuthEvent {}

class LoginWithPassword extends AuthEvent {
  LoginWithPassword(this.mobile, this.password);

  final String? mobile;
  final String? password;
}

class LogOut extends AuthEvent {

}
