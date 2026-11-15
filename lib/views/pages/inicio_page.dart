import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:projeto_inventario_patrimonial_frontend/views/cores.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/widgets/card_acao.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({
    super.key,
    required this.onEscanear,
    required this.onAbrirInventario,
    required this.onAbrirRecebimentos,
    required this.podeReceberTransferencias,
    required this.carregandoPerfil,
    required this.erroPerfil,
    required this.onTentarCarregarPerfil,
  });

  // Ações da Home
  final VoidCallback onEscanear;
  final VoidCallback onAbrirInventario;
  final VoidCallback onAbrirRecebimentos;
  final VoidCallback onTentarCarregarPerfil;

  // Permissões e estado do perfil
  final bool podeReceberTransferencias;
  final bool carregandoPerfil;
  final String? erroPerfil;

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
          if (carregandoPerfil) ...[
            const SizedBox(height: 16),
            const Center(
              child: SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ] else if (erroPerfil != null) ...[
            const SizedBox(height: 16),
            const Text(
              'Não foi possível consultar suas permissões.',
              style: TextStyle(color: AppCores.textoSecundario),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: onTentarCarregarPerfil,
                child: const Text('Tentar novamente'),
              ),
            ),
          ] else if (podeReceberTransferencias) ...[
            const SizedBox(height: 12),
            CardAcao(
              icone: Icons.move_to_inbox_outlined,
              titulo: 'Recebimentos',
              descricao:
                  'Confira transferências pendentes para sua secretaria.',
              onTap: onAbrirRecebimentos,
            ),
          ],
        ],
      ),
    );
  }
}
