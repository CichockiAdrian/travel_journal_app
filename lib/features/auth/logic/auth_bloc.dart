import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

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
    if (state.isLoading) return;

    await _performAuthAction(
      emit: emit,
      action: () {
        return authRepository.login(
          email: event.email.trim(),
          password: event.password.trim(),
        );
      },
    );
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.isLoading) return;

    final email = event.email.trim();
    final password = event.password.trim();
    final repeatedPassword = event.repeatedPassword.trim();

    if (password != repeatedPassword) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Passwords do not match.',
          clearUser: true,
        ),
      );
      return;
    }

    await _performAuthAction(
      emit: emit,
      action: () {
        return authRepository.register(email: email, password: password);
      },
    );
  }

  Future<void> _performAuthAction({
    required Emitter<AuthState> emit,
    required Future<User?> Function() action,
  }) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearErrorMessage: true,
        clearUser: true,
      ),
    );

    try {
      final user = await action();

      emit(
        state.copyWith(
          status: AuthStatus.success,
          user: user,
          clearErrorMessage: true,
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: _getAuthErrorMessage(e.code),
          clearUser: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'An unexpected error occurred.',
          clearUser: true,
        ),
      );
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'The password is too weak. Use at least 6 characters.';
      case 'network-request-failed':
        return 'No internet connection.';
      default:
        return 'Could not complete the operation.';
    }
  }
}
