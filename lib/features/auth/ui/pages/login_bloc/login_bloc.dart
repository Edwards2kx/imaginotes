import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:imaginotes/features/auth/domain/errors/auth_error.dart';
import 'package:imaginotes/features/auth/domain/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(AuthRepository repository)
    : _repository = repository,
      super(LoginInitial()) {
    on<LoginAttemptEvent>(_onLoginAttemptEvent);
  }
  final AuthRepository _repository;

  _onLoginAttemptEvent(
    LoginAttemptEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final authResponse = await _repository.signInWithEmailAndPassword(
      event.email,
      event.password,
    );
    if (authResponse.isLeft) {
      emit(LoginError((authResponse.left.type)));
      return;
    }

    emit(LoginSuccess());
  }
}
