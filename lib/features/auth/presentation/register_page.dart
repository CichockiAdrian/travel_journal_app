import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> register() async {
    if (passwordController.text.trim() != repeatPasswordController.text.trim()) {
      setState(() {
        errorMessage = 'Hasła nie są takie same.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = _getAuthErrorMessage(e.code);
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Wystąpił nieoczekiwany błąd.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Konto z tym adresem email już istnieje.';
      case 'invalid-email':
        return 'Nieprawidłowy adres email.';
      case 'weak-password':
        return 'Hasło jest za słabe. Użyj minimum 6 znaków.';
      case 'network-request-failed':
        return 'Brak połączenia z internetem.';
      default:
        return 'Nie udało się utworzyć konta.';
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejestracja'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  Text(
                    'Utwórz konto',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Hasło',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: repeatPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Powtórz hasło',
                      prefixIcon: Icon(Icons.lock_reset),
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: isLoading ? null : register,
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Zarejestruj się'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}