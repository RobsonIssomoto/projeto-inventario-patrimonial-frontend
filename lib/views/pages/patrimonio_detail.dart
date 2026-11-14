import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/sala.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/cores.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/transferencia_page.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/widgets/localizacao_card.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/widgets/patrimonio_resumo_card.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/widgets/patrimonio_validation_card.dart';
import 'package:projeto_inventario_patrimonial_frontend/viewmodels/sala_viewmodel.dart';
import 'package:projeto_inventario_patrimonial_frontend/viewmodels/inventario_viewmodel.dart';

class PatrimonioDetail extends StatefulWidget {
  final Patrimonio patrimonio;

  const PatrimonioDetail({super.key, required this.patrimonio});

  @override
  State<PatrimonioDetail> createState() => _PatrimonioDetailState();
}

class _PatrimonioDetailState extends State<PatrimonioDetail> {
  final InventarioViewModel _inventarioViewModel = InventarioViewModel();
  final SalaViewModel _salaViewModel = SalaViewModel();

  final TextEditingController _observacaoController = TextEditingController();

  late String _statusSelecionado;
  late String _estadoSelecionado;

  Sala? _salaNova;

  bool _salvando = false;

  @override
  void initState() {
    super.initState();

    // A tela já abre com os dados atuais do patrimônio
    _statusSelecionado = widget.patrimonio.status;
    _estadoSelecionado = widget.patrimonio.estadoConservacao;
    _observacaoController.text = widget.patrimonio.observacoes;
  }

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }

  // TROCA DE SALA

  Future<void> _escolherSala() async {
    final secretariaId = widget.patrimonio.secretariaId;

    if (secretariaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Secretaria do patrimônio não informada.'),
        ),
      );
      return;
    }

    final salasFuture = _salaViewModel.buscarSalasDaSecretaria(secretariaId);

    final salaEscolhida = await showModalBottomSheet<Sala>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return FutureBuilder<List<Sala>>(
          future: salasFuture,
          builder: (context, snapshot) {
            // Carregando
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            // Erro
            if (snapshot.hasError) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      snapshot.error.toString().replaceFirst('Exception: ', ''),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }

            // A sala atual não entra na lista
            final salas = (snapshot.data ?? [])
                .where((sala) => sala.id != widget.patrimonio.salaId)
                .toList();

            if (salas.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Não há outras salas cadastradas nesta secretaria.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }

            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
                    child: Text(
                      'Selecione a nova sala',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: salas.length,
                      itemBuilder: (context, index) {
                        final sala = salas[index];

                        return ListTile(
                          leading: const Icon(Icons.meeting_room_outlined),
                          title: Text(sala.nome),
                          onTap: () => Navigator.pop(context, sala),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (salaEscolhida == null) return; // fechou sem escolher

    setState(() {
      _salaNova = salaEscolhida;
    });
  }

  // SALVAR

  Future<void> _salvar() async {
    setState(() {
      _salvando = true;
    });

    try {
      await _inventarioViewModel.atualizarPatrimonio(
        id: widget.patrimonio.id ?? '',
        status: _statusSelecionado,
        estadoConservacao: _estadoSelecionado,
        observacoes: _observacaoController.text.trim(),
        salaId: _salaNova?.id,
      );

      if (!mounted) return;

      final messenger = ScaffoldMessenger.of(context);

      Navigator.pop(context, true);

      if (_salaNova != null) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Patrimônio atualizado com sucesso.')),
        );
      } else {
        messenger.showSnackBar(
          const SnackBar(content: Text('Patrimônio atualizado com sucesso.')),
        );
      }
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        _salvando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  // NAVEGAÇÃO

  void _abrirTransferencia() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransferenciaPage(patrimonio: widget.patrimonio),
      ),
    );
  }

  void _abrirHistorico() {
    // TODO: abrir a tela de Histórico de Movimentações
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Histórico de movimentações em breve.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.fundo,

      // BOTÕES FIXOS NO RODAPÉ (sempre visíveis, sem precisar rolar)
      bottomNavigationBar: _barraDeAcoes(),

      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO FIXO
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: BackButton(color: AppCores.azulEscuro),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Detalhes do Patrimônio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Histórico: ícone no canto do cabeçalho
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      tooltip: 'Histórico de movimentações',
                      icon: const Icon(
                        Icons.history,
                        color: AppCores.azulEscuro,
                      ),
                      onPressed: _abrirHistorico,
                    ),
                  ),
                ],
              ),
            ),

            // CONTEÚDO ROLÁVEL
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. DADOS PRINCIPAIS (somente leitura)
                    PatrimonioResumoCard(patrimonio: widget.patrimonio),

                    // 2. LOCALIZAÇÃO (trocar sala / transferir secretaria)
                    LocalizacaoCard(
                      secretaria: widget.patrimonio.secretaria,
                      salaAtual: widget.patrimonio.sala,
                      salaNova: _salaNova?.nome,
                      onTrocarSala: _escolherSala,
                      onTransferir: _abrirTransferencia,
                      onDesfazer: () {
                        setState(() {
                          _salaNova = null;
                        });
                      },
                    ),

                    // 3. VALIDAÇÃO (conferência)
                    PatrimonioValidationCard(
                      statusSelecionado: _statusSelecionado,
                      estadoSelecionado: _estadoSelecionado,
                      observacaoController: _observacaoController,
                      onStatusChanged: (status) {
                        setState(() {
                          _statusSelecionado = status;
                        });
                      },
                      onEstadoChanged: (estado) {
                        setState(() {
                          _estadoSelecionado = estado;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Salvar em cima e Cancelar embaixo, fixos no rodapé
  Widget _barraDeAcoes() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SafeArea(
        top: false,
        child: Column(
          // Ocupa só a altura dos botões (sem isso a barra tomaria a tela toda)
          mainAxisSize: MainAxisSize.min,
          // Estica os botões na largura toda
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _salvando ? null : _salvar,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppCores.azul,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppCores.azulDesabilitado,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _salvando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Salvar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _salvando ? null : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppCores.azul),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
