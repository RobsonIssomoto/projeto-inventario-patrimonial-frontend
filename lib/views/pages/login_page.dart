import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/cores.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/home_page.dart';
import 'package:projeto_inventario_patrimonial_frontend/viewmodels/login_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para capturar o texto dos campos
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // Alternar a visibilidade da senha
  bool _senhaOculta = true;

  // Login loading
  bool _carregando = false;

  final LoginViewModel _viewModel = LoginViewModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) return;

    // Liga o loading
    setState(() {
      _carregando = true;
    });

    try {
      await _viewModel.login(
        email: _emailController.text,
        senha: _senhaController.text,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (error) {
      if (!mounted) return;

      // Desativa o loading
      setState(() {
        _carregando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail ou senha inválidos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.fundo,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/imagens/prefeitura-de-atibaia-preto.png',
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      // Evita crash caso a imagem mude de pasta ou falte no asset
                      return const Icon(
                        Icons.business,
                        size: 100,
                        color: AppCores.azul,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Entrar',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppCores.azulEscuro,
                  ),
                ),
                const SizedBox(height: 24),

                // Campo de Email
                TextFormField(
                  controller: _emailController,
                  validator: _viewModel.validateEmail,
                  decoration: InputDecoration(
                    labelText: 'Digite seu e-mail',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Campo de Senha
                TextFormField(
                  controller: _senhaController,
                  obscureText: _senhaOculta,
                  validator: _viewModel.validatePassword,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Digite sua senha',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _senhaOculta ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _senhaOculta = !_senhaOculta;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Botão Entrar
                ElevatedButton(
                  // evita cliques repetidos
                  onPressed: _carregando ? null : _entrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppCores.azul,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppCores.azulDesabilitado,
                    disabledForegroundColor: Colors.white,
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
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Entrar',
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
