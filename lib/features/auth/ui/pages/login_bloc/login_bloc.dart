import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginAttemptEvent>(_onLoginAttemptEvent);
  }

  final auth = FirebaseAuth.instance;

  void _onLoginAttemptEvent(
    LoginAttemptEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final authResponse = await auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      if (authResponse.user != null) {
        // emit(LoginSuccess());
      } else {
        // emit(LoginFailure('User not found'));
      }
    } catch (e) {
      // emit(LoginFailure(e.toString()));
      debugPrint('error: $e');
    }
  }
}
