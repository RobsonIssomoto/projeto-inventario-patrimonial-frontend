import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/login_page.dart';

class CriarSenhaPage extends StatefulWidget {
  final String? oobCode;

  const CriarSenhaPage({super.key, this.oobCode});

  @override
  State<CriarSenhaPage> createState() => _CriarSenhaPageState();
}

class _CriarSenhaPageState extends State<CriarSenhaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  bool _novaSenhaOculta = true;
  bool _confirmarSenhaOculta = true;
  bool _carregando = false;

  @override
  void dispose() {
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _criarSenha() async {
    if (_carregando) return;

    final codigo = widget.oobCode;

    if (codigo == null || codigo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Link inválido ou expirado. Tente abrir o link novamente.',
          ),
        ),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;
    final novaSenha = _novaSenhaController.text.trim();

    setState(() {
      _carregando = true;
    });

    try {
      await FirebaseAuth.instance.verifyPasswordResetCode(codigo);
      await FirebaseAuth.instance.confirmPasswordReset(
        code: codigo,
        newPassword: novaSenha,
      );

      if (!mounted) return;

      _novaSenhaController.clear();
      _confirmarSenhaController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha criada com sucesso. Faça Login para continuar.'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } on FirebaseAuthException catch (erro) {
      if (!mounted) return;

      String mensagem;

      switch (erro.code) {
        case 'expired-action-code':
          mensagem = 'Este link expirou. Solicite um novo link.';
          break;

        case 'invalid-action-code':
          mensagem = 'Este link é inválido ou já foi utilizado.';
          break;

        case 'weak-password':
          mensagem = 'A senha não atende aos requisitos de segurança.';
          break;

        case 'user-disabled':
          mensagem = 'Esta conta está desativada. Entre em contato com o administrador.';
          break;

        case 'user-not-found':
          mensagem = 'A conta associada a este link não está disponível.';
          break;

        case 'network-request-failed':
          mensagem = 'Não foi possível conectar. Verifique sua conexão.';
          break;

        default:
          mensagem = 'Não foi possível criar a senha. Tente novamente.';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensagem)));
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorreu um erro inesperado. Tente novamente.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F9),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Criar senha',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Defina uma senha para acessar o sistema.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 32),
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
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe a nova senha.';
                    }

                    if (valor.trim().length < 6) {
                      return 'A senha deve ter no mínimo 6 caracteres.';
                    }

                    return null;
                  },
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
                    if (valor == null || valor.isEmpty) {
                      return 'Confirme a nova senha.';
                    }
                    if (valor != _novaSenhaController.text) {
                      return 'As senhas não coincidem.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _carregando ? null : _criarSenha,
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
                          'Criar',
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
