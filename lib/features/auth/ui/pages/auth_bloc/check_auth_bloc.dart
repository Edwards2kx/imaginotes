import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:imaginotes/features/auth/domain/repositories/auth_repository.dart';

part 'check_auth_event.dart';
part 'check_auth_state.dart';

class CheckAuthBloc extends Bloc<CheckAuthEvent, CheckAuthState> {
  CheckAuthBloc({required AuthRepository repository})
    : _authRepository = repository,

      super(CheckAuthInitial()) {
    on<CheckAuthStartEvent>(_checkAuthStartEvent);
    on<Logout>(_logoutEvent);
  }

  final AuthRepository _authRepository;

  _checkAuthStartEvent(event, emit) async {
    emit(CheckAuthLoading());
    final isSignedIn = await _authRepository.isSignedIn();
    if (isSignedIn) {
      emit(CheckAuthLogged());
    } else {
      emit(CheckAuthError(errorMessage: 'No hay un usuario logueado'));
    }
  }

  _logoutEvent(event, emit) async {
    try {
      _authRepository.signOut();
      emit(CheckAuthUnlogged());
    } catch (e) {
      emit(CheckAuthError(errorMessage: 'Error al cerrar sesión'));
    }
  }
}
