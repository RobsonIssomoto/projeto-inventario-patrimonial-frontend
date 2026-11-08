import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/cores.dart';

/// Card de localização do patrimônio.
///
/// - Secretaria: botão "Transferir" abre a tela de transferência.
/// - Sala: botão "Trocar" troca a sala dentro da mesma secretaria.
class LocalizacaoCard extends StatelessWidget {
  final String secretaria;
  final String salaAtual;

  // Sala escolhida pelo usuário (null = não trocou)
  final String? salaNova;

  final VoidCallback onTrocarSala;
  final VoidCallback onDesfazer;
  final VoidCallback onTransferir;

  const LocalizacaoCard({
    super.key,
    required this.secretaria,
    required this.salaAtual,
    required this.salaNova,
    required this.onTrocarSala,
    required this.onDesfazer,
    required this.onTransferir,
  });

  @override
  Widget build(BuildContext context) {
    final trocouSala = salaNova != null;

    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.location_on, color: AppCores.azulEscuro, size: 20),
                SizedBox(width: 6),
                Text(
                  'Localização',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // SECRETARIA (bloqueada)
            Row(
              children: [
                const Icon(
                  Icons.apartment,
                  size: 18,
                  color: AppCores.textoSecundario,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Secretaria / Setor',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppCores.textoSecundario,
                        ),
                      ),
                      Text(
                        secretaria,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                _botao('Transferir', AppCores.laranja, onTransferir),
              ],
            ),

            const Divider(height: 24),

            // SALA
            Row(
              children: [
                const Icon(
                  Icons.meeting_room_outlined,
                  size: 18,
                  color: AppCores.textoSecundario,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sala / Dependência',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppCores.textoSecundario,
                        ),
                      ),
                      Text(
                        salaAtual,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          // Sala antiga fica riscada quando há troca
                          color: trocouSala
                              ? AppCores.textoSecundario
                              : AppCores.texto,
                          decoration: trocouSala
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                _botao('Trocar', AppCores.azul, onTrocarSala),
              ],
            ),

            // NOVA SALA
            if (trocouSala) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                decoration: BoxDecoration(
                  color: AppCores.azulClaro,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: AppCores.azulEscuro,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Nova sala: $salaNova',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppCores.azulEscuro,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onDesfazer,
                      child: const Text('Desfazer'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Botão com borda e largura fixa: "Transferir" e "Trocar" ficam do mesmo tamanho
  Widget _botao(String texto, Color cor, VoidCallback onPressed) {
    return SizedBox(
      width: 110,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: cor,
          side: BorderSide(color: cor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(texto),
      ),
    );
  }
}
