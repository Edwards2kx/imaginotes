import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/auth_repository.dart';

part 'create_account_event.dart';
part 'create_account_state.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  CreateAccountBloc({required AuthRepository repository})
    : _authRepository = repository,
      super(CreateAccountInitial()) {
    on<CreateAccountAttempt>(_createAccountAttempt);
  }

  final AuthRepository _authRepository;

  void _createAccountAttempt(CreateAccountAttempt event, emit) async {
    if (event.email.isEmpty ||
        event.password.isEmpty ||
        event.confirmPassword.isEmpty) {
      emit(
        CreateAccountError(
          errorMessage: 'El email o la contraseña no pueden estar vacíos',
        ),
      );
      return;
    }

    if (event.password != event.confirmPassword) {
      emit(CreateAccountError(errorMessage: 'Las contraseñas no coinciden'));
      return;
    }
    emit(CreateAccountLoading());
    final response = await _authRepository.registerWithEmailAndPassword(
      event.email,
      event.password,
    );

    if (response.isLeft) {
      emit(CreateAccountError(errorMessage: response.left.type.description));
      return;
    } else {
      emit(CreateAccountSuccess());
    }
  }
}
