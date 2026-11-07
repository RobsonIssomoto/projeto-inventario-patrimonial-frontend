import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlterarSenhaPage extends StatefulWidget {
  const AlterarSenhaPage({super.key});

  @override
  State<AlterarSenhaPage> createState() => _AlterarSenhaPageState();
}

class _AlterarSenhaPageState extends State<AlterarSenhaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _senhaAtualController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  bool _senhaAtualOculta = true;
  bool _novaSenhaOculta = true;
  bool _confirmarSenhaOculta = true;
  bool _carregando = false;

  @override
  void dispose() {
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _alterarSenha() async {
    if (_carregando) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();

    final senhaAtual = _senhaAtualController.text;
    final novaSenha = _novaSenhaController.text;

    setState(() {
      _carregando = true;
    });

    try {
      final usuario = FirebaseAuth.instance.currentUser;

      if (usuario == null) {
        _mostrarMensagem('Sua sessão terminou. Entre novamente.');
        return;
      }

      final email = usuario.email;

      if (email == null || email.isEmpty) {
        _mostrarMensagem('Não foi possível identificar o e-mail da conta.');
        return;
      }

      final usaSenha = usuario.providerData.any(
        (provedor) => provedor.providerId == 'password',
      );

      if (!usaSenha) {
        _mostrarMensagem('Esta conta não utiliza login por e-mail e senha.');
        return;
      }

      final credencial = EmailAuthProvider.credential(
        email: email,
        password: senhaAtual,
      );

      await usuario.reauthenticateWithCredential(credencial);

      if (!mounted) return;

      await usuario.updatePassword(novaSenha);

      if (!mounted) return;

      _senhaAtualController.clear();
      _novaSenhaController.clear();
      _confirmarSenhaController.clear();

      _mostrarMensagem('Senha alterada com sucesso.');
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String mensagem;

      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
        case 'invalid-login-credentials':
          mensagem = 'Confira a senha atual e tente novamente.';
          break;
        case 'weak-password':
        case 'password-does-not-meet-requirements':
          mensagem = 'A nova senha não atende aos requisitos de segurança.';
          break;
        case 'requires-recent-login':
          mensagem = 'Entre novamente antes de alterar a senha.';
          break;
        case 'network-request-failed':
          mensagem = 'Falha de conexão. Verifique sua internet.';
          break;
        case 'too-many-requests':
          mensagem = 'Muitas tentativas. Aguarde antes de tentar novamente.';
          break;
        case 'user-disabled':
          mensagem = 'Esta conta está desativada.';
          break;
        case 'user-not-found':
        case 'invalid-user-token':
        case 'user-token-expired':
          mensagem = 'Sua sessão não é mais válida. Entre novamente.';
          break;
        default:
          mensagem = 'Não foi possível alterar a senha. Tente novamente.';
      }

      _mostrarMensagem(mensagem);
    } catch (_) {
      if (!mounted) return;

      _mostrarMensagem('Ocorreu um erro inesperado ao alterar a senha.');
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  void _mostrarMensagem(String mensagem) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F9),
      appBar: AppBar(
        title: const Text('Alterar senha'),
        backgroundColor: const Color(0xFFEEF2F9),
        foregroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // const Text(
                //   'Alterar senha',
                //   style: TextStyle(
                //     fontSize: 32,
                //     fontWeight: FontWeight.bold,
                //     color: Color(0xFF1E3A8A),
                //   ),
                // ),
                // const SizedBox(height: 24),
                TextFormField(
                  controller: _senhaAtualController,
                  obscureText: _senhaAtualOculta,
                  decoration: InputDecoration(
                    labelText: 'Senha atual',
                    hintText: 'Digite sua senha atual',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _senhaAtualOculta
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _senhaAtualOculta = !_senhaAtualOculta;
                        });
                      },
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Informe a senha atual.';
                    }

                    return null;
                  },
                  enabled: !_carregando,
                  autocorrect: false,
                  enableSuggestions: false,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _novaSenhaController,
                  obscureText: _novaSenhaOculta,
                  decoration: InputDecoration(
                    labelText: 'Nova senha',
                    hintText: 'Digite a nova senha',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _novaSenhaOculta
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _novaSenhaOculta = !_novaSenhaOculta;
                        });
                      },
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Informe a nova senha.';
                    }

                    if (valor.length < 6) {
                      return 'A nova senha deve ter no mínimo 6 caracteres.';
                    }

                    if (valor == _senhaAtualController.text) {
                      return 'A nova senha deve ser diferente da senha atual.';
                    }

                    return null;
                  },
                  enabled: !_carregando,
                  autocorrect: false,
                  enableSuggestions: false,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmarSenhaController,
                  obscureText: _confirmarSenhaOculta,
                  decoration: InputDecoration(
                    labelText: 'Confirmar senha',
                    hintText: 'Digite a nova senha novamente',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmarSenhaOculta
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmarSenhaOculta = !_confirmarSenhaOculta;
                        });
                      },
                    ),
                  ),
                  validator: (valor) {
                    if (valor != _novaSenhaController.text) {
                      return 'As senhas não coincidem.';
                    }
                    return null;
                  },
                  enabled: !_carregando,
                  autocorrect: false,
                  enableSuggestions: false,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _carregando ? null : _alterarSenha,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _carregando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Alterar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
