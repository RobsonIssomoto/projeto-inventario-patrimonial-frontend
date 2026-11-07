import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:projeto_inventario_patrimonial_frontend/views/pages/alterar_senha_page.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.onVoltar});

  final VoidCallback onVoltar;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const String baseUrl = 'http://localhost:3000/api/v1';

  bool carregando = true;
  String erro = '';
  Map<String, dynamic>? usuario;
  bool _saindo = false;

  @override
  void initState() {
    super.initState();
    carregarPerfil();
  }

  Future<void> carregarPerfil() async {
    try {
      final usuarioFirebase = FirebaseAuth.instance.currentUser;

      if (usuarioFirebase == null) {
        if (!mounted) return;

        setState(() {
          carregando = false;
          erro = 'Usuário não autenticado.';
        });
        return;
      }

      final token = await usuarioFirebase.getIdToken();

      if (token == null || token.isEmpty) {
        if (!mounted) return;

        setState(() {
          carregando = false;
          erro = 'Não foi possível validar sua sessão. Entre novamente.';
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
          usuario = dados as Map<String, dynamic>;
          carregando = false;
          erro = '';
        });
      } else {
        setState(() {
          carregando = false;
          erro = 'Não foi possível carregar o perfil.';
        });
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        carregando = false;
        erro = 'Erro ao carregar o perfil.';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEEF2F9),
        foregroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          tooltip: 'Voltar ao início',
          onPressed: _saindo ? null : widget.onVoltar,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          children: [
            _buildPerfil(),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Conta',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              enabled: !_saindo,
              leading: const Icon(Icons.lock_outline, color: Color(0xFF2563EB)),
              title: const Text('Alterar senha'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _saindo
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AlterarSenhaPage(),
                        ),
                      );
                    },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              enabled: !_saindo,
              leading: _saindo
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.logout, color: Color(0xFFB91C1C)),
              title: Text(
                _saindo ? 'Saindo...' : 'Sair',
                style: const TextStyle(color: Color(0xFFB91C1C)),
              ),
              onTap: _saindo ? null : _sair,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerfil() {
    if (carregando) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (erro.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(erro, style: const TextStyle(color: Color(0xFFB91C1C))),
      );
    }

    final nome = _textoOuPadrao(usuario?['nome'], 'Nome não informado');

    final email = _textoOuPadrao(usuario?['email'], 'E-mail não informado');

    final perfil = _textoOuPadrao(usuario?['perfil'], 'Perfil não informado');

    final perfilExibido = '${perfil[0].toUpperCase()}${perfil.substring(1)}';

    final secretariaDados = usuario?['secretaria'];

    final secretaria = secretariaDados is Map
        ? _textoOuPadrao(secretariaDados['nome'], 'Não vinculada')
        : 'Não vinculada';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundColor: Color(0xFFDBEAFE),
              child: Icon(
                Icons.person_outline,
                size: 36,
                color: Color(0xFF1E3A8A),
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    perfilExibido,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        _buildDadoPerfil(
          rotulo: 'E-mail',
          valor: email,
          icone: Icons.email_outlined,
        ),
        const SizedBox(height: 20),
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
        Icon(icone, size: 22, color: const Color(0xFF64748B)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rotulo,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 4),
              Text(
                valor,
                style: const TextStyle(fontSize: 16, color: Color(0xFF1E293B)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
