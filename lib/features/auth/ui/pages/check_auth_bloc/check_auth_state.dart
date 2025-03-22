part of 'check_auth_bloc.dart';

sealed class CheckAuthState extends Equatable {
  const CheckAuthState();

  @override
  List<Object> get props => [];
}

final class CheckAuthInitial extends CheckAuthState {}

final class CheckAuthLoading extends CheckAuthState {}

final class CheckAuthLogged extends CheckAuthState {}

final class CheckAuthError extends CheckAuthState {
  final String errorMessage;
  const CheckAuthError({required this.errorMessage});
}

// enum CheckAuthStatus { initial, loading, success, failure }

// final class CheckAuthState {
//   const CheckAuthState({
//     this.status = CheckAuthStatus.initial,
//     this.errorMessage,
//   });
//   final CheckAuthStatus status;
//   final String? errorMessage;
// }
