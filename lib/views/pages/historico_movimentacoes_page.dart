import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/movimentacao.dart';
import 'package:projeto_inventario_patrimonial_frontend/viewmodels/movimentacao_viewmodel.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/cores.dart';

class HistoricoMovimentacoesPage extends StatefulWidget {
  final String patrimonioId;

  const HistoricoMovimentacoesPage({super.key, required this.patrimonioId});

  @override
  State<HistoricoMovimentacoesPage> createState() =>
      _HistoricoMovimentacoesPageState();
}

class _HistoricoMovimentacoesPageState
    extends State<HistoricoMovimentacoesPage> {
  final MovimentacaoViewModel _viewModel = MovimentacaoViewModel();

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    await _viewModel.carregarPorPatrimonio(widget.patrimonioId);

    if (mounted) {
      setState(() {});
    }
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year} '
        '${data.hour.toString().padLeft(2, '0')}:'
        '${data.minute.toString().padLeft(2, '0')}';
  }

  String _tituloMovimentacao(Movimentacao movimentacao) {
    switch (movimentacao.tipo) {
      case 'atualizacao_localizacao':
        return 'Troca de sala';
      case 'transferencia':
        return 'Transferência';
      case 'conferencia':
        return 'Conferência';
      default:
        return 'Movimentação';
    }
  }

  String _descricaoMovimentacao(Movimentacao movimentacao) {
    if (movimentacao.tipo == 'atualizacao_localizacao') {
      return '${movimentacao.salaOrigem} → ${movimentacao.salaDestino}';
    }

    if (movimentacao.tipo == 'transferencia') {
      final origem = movimentacao.secretariaOrigem;
      final destino = movimentacao.secretariaDestino;

      final nomeOrigem = origem != null && origem.isNotEmpty
          ? origem
          : movimentacao.secretaria;

      final nomeDestino = destino != null && destino.isNotEmpty
          ? destino
          : 'Destino não informado';

      return '$nomeOrigem → $nomeDestino';
    }

    return movimentacao.observacoes?.isNotEmpty == true
        ? movimentacao.observacoes!
        : 'Sem descrição';
  }

  Future<void> _cancelarTransferencia(String movimentacaoId) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar transferência'),
        content: const Text(
          'Deseja realmente cancelar esta transferência pendente?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Não'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sim, cancelar'),
          ),
        ],
      ),
    );

    if (confirmado != true) return;

    await _viewModel.cancelarTransferencia(movimentacaoId);

    if (!mounted) return;

    final erro = _viewModel.erro;

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transferência cancelada com sucesso.')),
    );

    await _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.fundo,
      appBar: AppBar(
        backgroundColor: AppCores.fundo,
        foregroundColor: AppCores.azulEscuro,
        title: const Text(
          'Histórico',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildCorpo(),
    );
  }

  Widget _buildCorpo() {
    if (_viewModel.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined),
              const SizedBox(height: 12),
              Text(_viewModel.erro!),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _carregar,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_viewModel.movimentacoes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Nenhuma movimentação registrada.'),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _viewModel.movimentacoes.length,
      itemBuilder: (context, index) {
        final movimentacao = _viewModel.movimentacoes[index];

        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _tituloMovimentacao(movimentacao),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _statusTransferencia(movimentacao.statusTransferencia),
                  ],
                ),

                const SizedBox(height: 8),
                Text(_descricaoMovimentacao(movimentacao)),
                const SizedBox(height: 8),
                Text(
                  'Responsável: ${movimentacao.usuario}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppCores.textoSecundario,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatarData(movimentacao.dataHora),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppCores.textoSecundario,
                  ),
                ),
                if (movimentacao.tipo == 'transferencia' &&
                    movimentacao.statusTransferencia == 'pendente') ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: () => _cancelarTransferencia(movimentacao.id),
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('Cancelar transferência'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        side: BorderSide(color: Colors.red.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statusTransferencia(String? status) {
    final String texto;
    final Color cor;

    switch (status) {
      case 'pendente':
        texto = 'Pendente';
        cor = Colors.orange.shade900;
        break;
      case 'recebida':
        texto = 'Recebida';
        cor = Colors.green.shade800;
        break;
      case 'cancelada':
        texto = 'Cancelada';
        cor = Colors.red.shade700;
        break;
      default:
        texto = 'Status não informado';
        cor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: TextStyle(color: cor, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
