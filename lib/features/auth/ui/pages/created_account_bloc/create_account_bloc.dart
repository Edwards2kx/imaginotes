import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

part 'create_account_event.dart';
part 'create_account_state.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  CreateAccountBloc() : super(CreateAccountInitial()) {
    on<CreateAccountEvent>((event, emit) {

      if (event is CreateAccountAttempt) {
    final FirebaseAuth auth = FirebaseAuth.instance;
        auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        ).then((value) {
          debugPrint('user created $value');
          
          // emit(CreateAccountSuccess());
        }).catchError((error) {
          debugPrint('error: $error');
          // emit(CreateAccountFailure(error.toString()));
        });
      }
      
    });
  }
}
