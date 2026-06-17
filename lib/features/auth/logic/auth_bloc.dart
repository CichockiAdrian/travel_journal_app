import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String repeatedPassword;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.repeatedPassword,
  });
}

enum AuthStatus { initial, loading, success, failure }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({required this.status, this.errorMessage});

  const AuthState.initial() : status = AuthStatus.initial, errorMessage = null;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({AuthStatus? status, String? errorMessage}) {
    return AuthState(status: status ?? this.status, errorMessage: errorMessage);
  }
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthState.initial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    try {
      await authRepository.login(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      emit(state.copyWith(status: AuthStatus.success, errorMessage: null));
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: _getAuthErrorMessage(e.code),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Wystąpił nieoczekiwany błąd.',
        ),
      );
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    final email = event.email.trim();
    final password = event.password.trim();
    final repeatedPassword = event.repeatedPassword.trim();

    if (password != repeatedPassword) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Hasła nie są takie same.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    try {
      await authRepository.register(email: email, password: password);

      emit(state.copyWith(status: AuthStatus.success, errorMessage: null));
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: _getAuthErrorMessage(e.code),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Wystąpił nieoczekiwany błąd.',
        ),
      );
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Nieprawidłowy adres email.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Nieprawidłowy email lub hasło.';
      case 'email-already-in-use':
        return 'Konto z tym adresem email już istnieje.';
      case 'weak-password':
        return 'Hasło jest za słabe. Użyj minimum 6 znaków.';
      case 'network-request-failed':
        return 'Brak połączenia z internetem.';
      default:
        return 'Nie udało się wykonać operacji.';
    }
  }
}
