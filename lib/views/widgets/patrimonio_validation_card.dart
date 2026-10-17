import 'package:flutter/material.dart';

class PatrimonioValidationCard extends StatelessWidget {
  final String? statusSelecionado;
  final String? estadoSelecionado;

  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onEstadoChanged;

  const PatrimonioValidationCard({
    super.key,
    required this.statusSelecionado,
    required this.estadoSelecionado,
    required this.onStatusChanged,
    required this.onEstadoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Validação de Patrimônio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              'Atualize a situação do patrimônio após a inspeção',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // STATUS DA CONFERÊNCIA
            _grupo(
              titulo: 'Status da Conferência',
              opcoes: const ['Conferido', 'Pendente', 'Não localizado'],
              icones: const [
                Icons.check_circle,
                Icons.watch_later,
                Icons.cancel,
              ],
              cores: const [
                Color(0xFF10B981),
                Color(0xFFF9A825),
                Color(0xFFEF4444),
              ],
              valorSelecionado: statusSelecionado,
              onChanged: onStatusChanged,
            ),

            const SizedBox(height: 24),

            // ESTADO DE CONSERVAÇÃO
            _grupo(
              titulo: 'Estado de Conservação',
              opcoes: const ['Novo', 'Bom', 'Regular', 'Ruim', 'Inservível'],
              icones: const [
                Icons.circle,
                Icons.circle,
                Icons.circle,
                Icons.circle,
                Icons.circle,
              ],
              cores: const [
                Colors.teal,
                Color(0xFF2563EB),
                Color(0xFFF9B625),
                Color(0xFFF97316),
                Colors.red,
              ],
              valorSelecionado: estadoSelecionado,
              onChanged: onEstadoChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _grupo({
    required String titulo,
    required List<String> opcoes,
    required List<IconData> icones,
    required List<Color> cores,
    required String? valorSelecionado,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (int i = 0; i < opcoes.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: _opcao(
                  texto: opcoes[i],
                  icone: icones[i],
                  cor: cores[i],
                  selecionado: valorSelecionado == opcoes[i],
                  onTap: () => onChanged(opcoes[i]),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _opcao({
    required String texto,
    required IconData icone,
    required Color cor,
    required bool selecionado,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 80,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          minimumSize: Size.zero,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
          backgroundColor: selecionado
              ? cor.withAlpha(30)
              : const Color(0xFFF8F8F8),
          foregroundColor: selecionado ? cor : Colors.grey.shade700,
          side: BorderSide(
            color: selecionado ? cor : Colors.grey.shade300,
            width: selecionado ? 1.5 : 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icone,
              size: icone == Icons.circle ? 10 : 20,
              color: icone == Icons.circle || selecionado
                  ? cor
                  : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              texto,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selecionado ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
