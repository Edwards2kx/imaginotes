part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}


class LoginAttemptEvent extends LoginEvent {
  final String email;
  final String password;

  LoginAttemptEvent(this.email, this.password);
}