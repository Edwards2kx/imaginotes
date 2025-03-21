part of 'create_account_bloc.dart';

@immutable
sealed class CreateAccountEvent {}

class CreateAccountAttempt extends CreateAccountEvent {
  final String email;
  final String password;

  CreateAccountAttempt(this.email, this.password);
}
