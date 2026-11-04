import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel {
  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Informe o seu e-mail';
    }

    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');

    if (!emailRegex.hasMatch(email)) {
      return 'E-mail inválido';
    }

    return null;
  }

  String? validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Informe a sua senha';
    }

    return null;
  }

  Future<User> login({required String email, required String senha}) async {
    final credencial = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );

    final usuario = credencial.user;

    if (usuario == null) {
      throw Exception('Não foi possível autenticar o usuário.');
    }

    return usuario;
  }
}
