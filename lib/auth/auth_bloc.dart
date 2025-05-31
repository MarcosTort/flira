import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  void _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) {
    // Simple validation for demo purposes
    if (event.username.isNotEmpty && event.password.isNotEmpty) {
      emit(AuthAuthenticated(username: event.username));
    } else {
      emit(AuthError('Username and password cannot be empty'));
      emit(AuthUnauthenticated());
    }
  }

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }
}
