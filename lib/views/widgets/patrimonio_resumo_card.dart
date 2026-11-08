import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/cores.dart';

/// Card do topo da tela de detalhes: número, status, descrição e
/// os dados cadastrais do patrimônio (somente leitura).
class PatrimonioResumoCard extends StatelessWidget {
  final Patrimonio patrimonio;

  const PatrimonioResumoCard({super.key, required this.patrimonio});

  // Converte a data para o formato dd/mm/aaaa
  String _formatarData(DateTime? data) {
    if (data == null) return 'Não informada';

    final local = data.toLocal();
    final dia = local.day.toString().padLeft(2, '0');
    final mes = local.month.toString().padLeft(2, '0');

    return '$dia/$mes/${local.year}';
  }

  // Cor do chip de status (mesmas cores do card de validação)
  Color _corDoStatus() {
    if (patrimonio.status == 'conferido') return AppCores.verde;
    if (patrimonio.status == 'nao_localizado') return AppCores.vermelho;
    return AppCores.amarelo;
  }

  @override
  Widget build(BuildContext context) {
    final corStatus = _corDoStatus();

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
            // LINHA 1: número (esquerda) e status (direita)
            Row(
              children: [
                _chip(
                  texto: patrimonio.numeroPatrimonio,
                  corFundo: AppCores.azulClaro,
                  corTexto: AppCores.azulEscuro,
                ),
                const Spacer(),
                _chip(
                  texto: patrimonio.statusFormatado,
                  corFundo: corStatus.withAlpha(30),
                  corTexto: corStatus,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // LINHA 2: descrição
            Text(
              patrimonio.descricao,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppCores.texto,
              ),
            ),

            const Divider(height: 24),

            // DADOS CADASTRAIS em duas colunas
            Row(
              children: [
                Expanded(child: _info('Categoria', patrimonio.categoria)),
                Expanded(
                  child: _info('Conservação', patrimonio.estadoFormatado),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _info(
                    'Cadastrado em',
                    _formatarData(patrimonio.cadastradoEm),
                  ),
                ),
                Expanded(
                  child: _info(
                    'Última atualização',
                    _formatarData(patrimonio.atualizadoEm),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Etiqueta pequena e arredondada
  Widget _chip({
    required String texto,
    required Color corFundo,
    required Color corTexto,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 12,
          color: corTexto,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Rótulo pequeno em cima e valor embaixo
  Widget _info(String rotulo, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rotulo,
          style: const TextStyle(fontSize: 12, color: AppCores.textoSecundario),
        ),
        const SizedBox(height: 2),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppCores.texto,
          ),
        ),
      ],
    );
  }
}
