import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/movimentacao.dart';
import 'package:projeto_inventario_patrimonial_frontend/viewmodels/recebimento_viewmodel.dart';
import 'package:projeto_inventario_patrimonial_frontend/viewmodels/sala_viewmodel.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/cores.dart';

class RecebimentosPage extends StatefulWidget {
  const RecebimentosPage({super.key});

  @override
  State<RecebimentosPage> createState() => _RecebimentosPageState();
}

class _RecebimentosPageState extends State<RecebimentosPage> {
  final RecebimentosViewModel _viewModel = RecebimentosViewModel();
  bool _processando = false;
  String? _movimentacaoEmProcessamento;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
  if (_processando || _viewModel.carregando) return;

  final operacao = _viewModel.carregar();

  setState(() {});

  await operacao;

  if (!mounted) return;

  setState(() {});
}

  String _formatarData(DateTime data) {
    final local = data.toLocal();

    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/'
        '${local.year} '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  Widget _cardRecebimento(Movimentacao movimentacao) {
    final numero = movimentacao.numeroPatrimonio;
    final descricao = movimentacao.descricaoPatrimonio;
    final origem = movimentacao.secretariaOrigem;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              numero != null && numero.isNotEmpty
                  ? 'Patrimônio $numero'
                  : 'Patrimônio não identificado',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppCores.azulEscuro,
              ),
            ),
            if (descricao != null && descricao.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(descricao),
            ],
            const SizedBox(height: 12),
            Text(
              'Origem: ${origem != null && origem.isNotEmpty ? origem : movimentacao.secretaria}',
            ),
            const SizedBox(height: 4),
            Text('Solicitado por: ${movimentacao.usuario}'),
            const SizedBox(height: 4),
            Text('Data: ${_formatarData(movimentacao.dataHora)}'),
            const SizedBox(height: 8),
            Text('Motivo: ${movimentacao.motivo ?? 'Não informado'}'),
            const SizedBox(height: 4),
            Text(
              'Justificativa: '
              '${movimentacao.justificativa ?? 'Não informada'}',
            ),
            const SizedBox(height: 12),
            const Text(
              'Aguardando recebimento',
              style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _processando || _viewModel.carregando
                    ? null
                    : () => _receberTransferencia(movimentacao),
                icon: _movimentacaoEmProcessamento == movimentacao.id
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.move_to_inbox_outlined, size: 18),
                label: Text(
                  _movimentacaoEmProcessamento == movimentacao.id
                      ? 'Processando...'
                      : 'Receber',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _conteudo() {
    if (_viewModel.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.erro != null && _viewModel.recebimentos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined),
              const SizedBox(height: 12),
              Text(_viewModel.erro!, textAlign: TextAlign.center),
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

    if (_viewModel.recebimentos.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Nenhuma transferência pendente de recebimento.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _viewModel.recebimentos.length,
        itemBuilder: (context, index) {
          return _cardRecebimento(_viewModel.recebimentos[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.fundo,
      appBar: AppBar(
        backgroundColor: AppCores.fundo,
        foregroundColor: AppCores.azulEscuro,
        title: const Text('Recebimentos'),
        actions: [
          IconButton(
            onPressed: _processando || _viewModel.carregando ? null : _carregar,
            tooltip: 'Atualizar',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _conteudo(),
    );
  }

  Future<void> _receberTransferencia(Movimentacao movimentacao) async {
    if (_processando || _viewModel.carregando) return;

    final secretariaDestinoId = movimentacao.secretariaDestinoId;

    if (secretariaDestinoId == null || secretariaDestinoId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível identificar a secretaria de destino.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _processando = true;
      _movimentacaoEmProcessamento = movimentacao.id;
    });

    try {
      final salasViewModel = SalaViewModel();

      await salasViewModel.carregarSalasDaSecretaria(secretariaDestinoId);

      if (!mounted) return;

      if (salasViewModel.erro != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(salasViewModel.erro!)));
        return;
      }

      final salas = salasViewModel.salas;

      if (salas.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nenhuma sala disponível para esta secretaria.'),
          ),
        );
        return;
      }

      String? salaSelecionadaId;

      final salaConfirmadaId = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, atualizarDialogo) {
              return AlertDialog(
                title: const Text('Receber transferência'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Escolha a sala em que o patrimônio ficará '
                        'após o recebimento.',
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Sala de destino',
                          border: OutlineInputBorder(),
                        ),
                        items: salas.map((sala) {
                          return DropdownMenuItem<String>(
                            value: sala.id,
                            child: Text(sala.nome),
                          );
                        }).toList(),
                        onChanged: (valor) {
                          atualizarDialogo(() {
                            salaSelecionadaId = valor;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Ao confirmar, a localização do patrimônio '
                        'será atualizada para esta secretaria e sala.',
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('Voltar'),
                  ),
                  FilledButton(
                    onPressed: salaSelecionadaId == null
                        ? null
                        : () {
                            Navigator.of(dialogContext).pop(salaSelecionadaId);
                          },
                    child: const Text('Confirmar recebimento'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (!mounted || salaConfirmadaId == null) return;

      final sucesso = await _viewModel.receber(
        movimentacaoId: movimentacao.id,
        salaDestinoId: salaConfirmadaId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            sucesso
                ? 'Transferência recebida com sucesso.'
                : _viewModel.erro ??
                      'Não foi possível receber a transferência.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _processando = false;
          _movimentacaoEmProcessamento = null;
        });
      }
    }
  }
}
