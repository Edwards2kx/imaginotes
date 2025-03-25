part of 'check_auth_bloc.dart';

sealed class CheckAuthState extends Equatable {
  const CheckAuthState();

  @override
  List<Object> get props => [];
}

final class CheckAuthInitial extends CheckAuthState {}

final class CheckAuthLoading extends CheckAuthState {}

final class CheckAuthLogged extends CheckAuthState {}

final class CheckAuthUnlogged extends CheckAuthState {}

final class CheckAuthError extends CheckAuthState {
  final String errorMessage;
  const CheckAuthError({required this.errorMessage});
}
