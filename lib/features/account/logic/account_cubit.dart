import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/data/auth_repository.dart';

class AccountState {
  final String email;
  final bool isLoading;

  const AccountState({required this.email, required this.isLoading});

  const AccountState.initial() : email = 'null', isLoading = false;

  AccountState copyWith({String? email, bool? isLoading}) {
    return AccountState(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AccountCubit extends Cubit<AccountState> {
  final AuthRepository authRepository;

  AccountCubit({required this.authRepository})
    : super(const AccountState.initial());

  void loadUserEmail() {
    final email = authRepository.currentUserEmail;

    emit(state.copyWith(email: email));
  }

  Future<void> logout() async {
    emit(state.copyWith(isLoading: true));

    await authRepository.logout();

    emit(state.copyWith(isLoading: false));
  }
}
