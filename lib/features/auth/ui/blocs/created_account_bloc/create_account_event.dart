part of 'create_account_bloc.dart';

@immutable
sealed class CreateAccountEvent {}

class CreateAccountAttempt extends CreateAccountEvent {
  final String email;
  final String password;
  final String confirmPassword;

  CreateAccountAttempt(this.email, this.password, this.confirmPassword);
}
