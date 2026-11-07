import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/cores.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/home_page.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/login_page.dart';

/// Mostra o logo enquanto verifica se o usuário já está logado:
/// - se estiver, vai direto para a Home;
/// - se não estiver, vai para o Login.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const Duration _duracaoAnimacao = Duration(milliseconds: 800);

  static const Duration _tempoMinimo = Duration(milliseconds: 3000);

  @override
  void initState() {
    super.initState();
    _verificarSessao();
  }

  Future<void> _verificarSessao() async {
    final tempoMinimo = Future.delayed(_tempoMinimo);

    // O Firebase guarda a sessão no aparelho. O primeiro valor destestream diz se existe um usuário logado ou não (null).
    final usuario = await FirebaseAuth.instance.authStateChanges().first;

    await tempoMinimo;

    if (!mounted) return;

    final Widget proximaTela;

    if (usuario != null) {
      proximaTela = const HomePage();
    } else {
      proximaTela = const LoginPage();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => proximaTela,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // 1. FUNDO EM DEGRADÊ (azul escuro em cima, azul embaixo)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppCores.azulEscuro, AppCores.azul],
          ),
        ),
        child: SafeArea(
          // 2. ANIMAÇÃO DE ENTRADA
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: _duracaoAnimacao,
            curve: Curves.easeOut,
            builder: (context, valor, child) {
              return Opacity(
                opacity: valor,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - valor)),
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                const Spacer(),

                Image.asset(
                  'assets/imagens/prefeitura-de-atibaia-branco.png',
                  height: 140,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.business,
                      size: 100,
                      color: Colors.white,
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Inventário Patrimonial',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // 3. SUBTÍTULO
                const Text(
                  'Controle e conferência de patrimônio',
                  style: TextStyle(color: AppCores.azulClaro, fontSize: 14),
                ),
                const SizedBox(height: 48),

                // 4. LOADING + TEXTO DO QUE ESTÁ ACONTECENDO
                const SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Verificando sessão...',
                  style: TextStyle(color: AppCores.azulClaro, fontSize: 13),
                ),

                const Spacer(),

                // 5. RODAPÉ
                const Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      Text(
                        'Projeto Integrador – 5º semestre',
                        style: TextStyle(
                          color: AppCores.azulClaro,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Versão 1.0.0',
                        style: TextStyle(
                          color: AppCores.azulClaro,
                          fontSize: 11,
                        ),
                      ),
                    ],
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
