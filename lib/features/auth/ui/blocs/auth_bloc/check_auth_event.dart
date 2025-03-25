part of 'check_auth_bloc.dart';

sealed class CheckAuthEvent extends Equatable {
  const CheckAuthEvent();

  @override
  List<Object> get props => [];
}


final class CheckAuthStartEvent extends CheckAuthEvent {
  const CheckAuthStartEvent();
}


final class Logout extends CheckAuthEvent {
  const Logout();
}