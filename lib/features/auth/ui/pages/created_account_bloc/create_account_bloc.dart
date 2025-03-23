import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_account_event.dart';
part 'create_account_state.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  CreateAccountBloc() : super(CreateAccountInitial()) {
    on<CreateAccountAttempt>(_createAccountAttempt);
  }
  void _createAccountAttempt(CreateAccountAttempt event, emit) async {
    if (event.password != event.confirmPassword) {
      emit(CreateAccountError(errorMessage: 'Las contraseñas no coinciden'));
      return;
    }
    emit(CreateAccountLoading());

    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(CreateAccountSuccess());
    } on FirebaseAuthException catch (e) {
      emit(CreateAccountError(errorMessage: e.message ?? 'Error desconocido'));
    } catch (e) {
      emit(CreateAccountError(errorMessage: e.toString()));
    }
  }
}
