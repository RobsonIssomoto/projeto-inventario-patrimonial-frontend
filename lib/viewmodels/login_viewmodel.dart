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
}
