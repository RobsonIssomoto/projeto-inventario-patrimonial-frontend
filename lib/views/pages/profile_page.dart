import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/login_page.dart';

import 'dart:convert';

import 'package:projeto_inventario_patrimonial_frontend/views/pages/alterar_senha_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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
        setState(() {
          carregando = false;
          erro = 'Usuário não autenticado.';
        });
        return;
      }

      final token = await usuarioFirebase.getIdToken();

      final resposta = await http.get(
        Uri.parse('$baseUrl/usuarios/eu'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);
        if (!mounted) return;
        setState(() {
          usuario = dados as Map<String, dynamic>;
          carregando = false;
        });
      } else {
        setState(() {
          carregando = false;
          erro = 'Não foi possível carregar o perfil.';
        });
      }
    } catch (e) {
      setState(() {
        carregando = false;
        erro = 'Erro de conexão com o servidor.';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Perfil',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(height: 24),
              _buildPerfil(),
              const SizedBox(height: 24),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.lock_outline,
                    color: Color(0xFF2563EB),
                  ),
                  title: const Text('Alterar senha'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AlterarSenhaPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _saindo ? null : _sair,
                icon: _saindo
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout),
                label: Text(_saindo ? 'Saindo...' : 'Sair'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerfil() {
    if (carregando) {
      return const Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (erro.isNotEmpty) {
      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(erro, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    final nome = usuario?['nome'] ?? 'Nome não informado';
    final email = usuario?['email'] ?? 'E-mail não informado';
    final secretaria =
        usuario?['secretaria']?['nome'] ?? 'Secretaria não informada';

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nome,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 8),
            Text(email),
            const SizedBox(height: 4),
            Text(secretaria),
          ],
        ),
      ),
    );
  }
}
