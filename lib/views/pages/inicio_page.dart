import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:projeto_inventario_patrimonial_frontend/views/cores.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/widgets/card_acao.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({
    super.key,
    required this.onEscanear,
    required this.onAbrirInventario,
  });

  // Ações da Home
  final VoidCallback onEscanear;
  final VoidCallback onAbrirInventario;

  // Nome do Firebase, senão o início do e-mail.
  String _nomeUsuario() {
    final usuario = FirebaseAuth.instance.currentUser;

    final nome = usuario?.displayName?.trim() ?? '';
    if (nome.isNotEmpty) return nome;

    final email = usuario?.email ?? '';
    if (email.isNotEmpty) return email.split('@').first;

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final nome = _nomeUsuario();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        children: [
          // SAUDAÇÃO
          Text(
            nome.isEmpty ? 'Olá!' : 'Olá, $nome!',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppCores.azulEscuro,
            ),
          ),
          const SizedBox(height: 8),

          // AÇÕES
          const Text(
            'O que deseja fazer?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppCores.texto,
            ),
          ),
          const SizedBox(height: 12),
          CardAcao(
            icone: Icons.qr_code_scanner,
            titulo: 'Escanear patrimônio',
            descricao: 'Leia a etiqueta para identificar um bem.',
            onTap: onEscanear,
          ),
          const SizedBox(height: 12),
          CardAcao(
            icone: Icons.assignment_outlined,
            titulo: 'Consultar inventário',
            descricao: 'Veja a lista completa de patrimônios.',
            onTap: onAbrirInventario,
          ),
        ],
      ),
    );
  }
}
