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
