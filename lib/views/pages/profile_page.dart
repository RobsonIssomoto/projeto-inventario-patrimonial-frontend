import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:projeto_inventario_patrimonial_frontend/views/cores.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/alterar_senha_page.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/login_page.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/widgets/card_acao.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.onVoltar});

  final VoidCallback onVoltar;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const String baseUrl = 'http://localhost:3000/api/v1';

  bool _carregando = true;
  String _erro = '';
  Map<String, dynamic>? _usuario;
  bool _saindo = false;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    setState(() {
      _carregando = true;
      _erro = '';
    });

    try {
      final usuarioFirebase = FirebaseAuth.instance.currentUser;

      if (usuarioFirebase == null) {
        if (!mounted) return;

        setState(() {
          _carregando = false;
          _erro = 'Usuário não autenticado.';
        });
        return;
      }

      final token = await usuarioFirebase.getIdToken();

      if (token == null || token.isEmpty) {
        if (!mounted) return;

        setState(() {
          _carregando = false;
          _erro = 'Não foi possível validar sua sessão. Entre novamente.';
        });
        return;
      }

      final resposta = await http.get(
        Uri.parse('$baseUrl/usuarios/eu'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (!mounted) return;

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        setState(() {
          _usuario = dados as Map<String, dynamic>;
          _carregando = false;
          _erro = '';
        });
      } else {
        setState(() {
          _carregando = false;
          _erro = 'Não foi possível carregar o perfil.';
        });
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _carregando = false;
        _erro =
            'Não foi possível carregar o perfil. '
            'Verifique a conexão e tente novamente.';
      });
    }
  }

  Future<void> _sair() async {
    if (_saindo) return;

    setState(() {
      _saindo = true;
    });

    try {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível sair. Tente novamente.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saindo = false;
        });
      }
    }
  }

  void _abrirAlterarSenha() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AlterarSenhaPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.fundo,
      appBar: AppBar(
        backgroundColor: AppCores.fundo,
        foregroundColor: AppCores.azulEscuro,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: const Text(
          'Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            // DADOS DO USUÁRIO
            _buildPerfil(),
            const SizedBox(height: 24),

            // AÇÕES DA CONTA
            const Text(
              'Conta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppCores.texto,
              ),
            ),
            const SizedBox(height: 12),
            CardAcao(
              icone: Icons.lock_outline,
              titulo: 'Alterar senha',
              descricao: 'Troque a senha usada para entrar no app.',
              onTap: _saindo ? null : _abrirAlterarSenha,
            ),
            const SizedBox(height: 24),

            // SAIR
            OutlinedButton.icon(
              onPressed: _saindo ? null : _sair,
              icon: _saindo
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.logout),
              label: Text(_saindo ? 'Saindo...' : 'Sair da conta'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppCores.vermelhoEscuro,
                side: const BorderSide(color: AppCores.vermelhoEscuro),
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card branco com os dados do usuário (mesmo estilo do CardAcao).
  Widget _buildPerfil() {
    Widget conteudo;

    if (_carregando) {
      conteudo = const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (_erro.isNotEmpty) {
      // Mesmo padrão de erro da tela de Inventário.
      conteudo = Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 40,
            color: AppCores.textoSecundario,
          ),
          const SizedBox(height: 12),
          Text(
            _erro,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppCores.textoSecundario),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _carregarPerfil,
            child: const Text('Tentar novamente'),
          ),
        ],
      );
    } else {
      conteudo = _buildDadosUsuario();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: conteudo,
    );
  }

  Widget _buildDadosUsuario() {
    final nome = _textoOuPadrao(_usuario?['nome'], 'Nome não informado');

    final email = _textoOuPadrao(_usuario?['email'], 'E-mail não informado');

    final perfil = _textoOuPadrao(_usuario?['perfil'], 'Perfil não informado');

    final perfilExibido = '${perfil[0].toUpperCase()}${perfil.substring(1)}';

    final secretariaDados = _usuario?['secretaria'];

    final secretaria = secretariaDados is Map
        ? _textoOuPadrao(secretariaDados['nome'], 'Não vinculada')
        : 'Não vinculada';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundColor: AppCores.azulClaro,
              child: Icon(
                Icons.person_outline,
                size: 36,
                color: AppCores.azulEscuro,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppCores.azulEscuro,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    perfilExibido,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppCores.textoSecundario,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Divider(color: Colors.grey.shade300),
        const SizedBox(height: 16),
        _buildDadoPerfil(
          rotulo: 'E-mail',
          valor: email,
          icone: Icons.email_outlined,
        ),
        const SizedBox(height: 16),
        _buildDadoPerfil(
          rotulo: 'Secretaria',
          valor: secretaria,
          icone: Icons.account_balance_outlined,
        ),
      ],
    );
  }

  String _textoOuPadrao(dynamic valor, String padrao) {
    if (valor is String && valor.trim().isNotEmpty) {
      return valor.trim();
    }

    return padrao;
  }

  Widget _buildDadoPerfil({
    required String rotulo,
    required String valor,
    required IconData icone,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icone, size: 22, color: AppCores.textoSecundario),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rotulo,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppCores.textoSecundario,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valor,
                style: const TextStyle(fontSize: 16, color: AppCores.texto),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
