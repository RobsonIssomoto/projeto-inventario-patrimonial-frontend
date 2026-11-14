import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/secretaria.dart';
import 'package:projeto_inventario_patrimonial_frontend/viewmodels/sala_viewmodel.dart';
import 'package:projeto_inventario_patrimonial_frontend/viewmodels/secretaria_viewmodel.dart';
import 'package:projeto_inventario_patrimonial_frontend/viewmodels/movimentacao_viewmodel.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/cores.dart';

class TransferenciaPage extends StatefulWidget {
  final Patrimonio patrimonio;

  const TransferenciaPage({super.key, required this.patrimonio});

  @override
  State<TransferenciaPage> createState() => _TransferenciaPageState();
}

class _TransferenciaPageState extends State<TransferenciaPage> {
  final SecretariaViewModel _secretariaViewModel = SecretariaViewModel();
  final SalaViewModel _salaViewModel = SalaViewModel();
  final MovimentacaoViewModel _movimentacaoViewModel = MovimentacaoViewModel();

  final TextEditingController _justificativaController =
      TextEditingController();

  static const List<String> _motivos = [
    'Remanejamento',
    'Substituição',
    'Manutenção',
    'Empréstimo',
    'Otimização',
  ];

  List<Secretaria> _secretarias = [];
  bool _carregandoSecretarias = true;
  String _erroSecretarias = '';

  bool _enviando = false;

  String? _secretariaDestinoId;
  String? _motivoSelecionado;

  @override
  void initState() {
    super.initState();
    _carregarSecretarias();
  }

  @override
  void dispose() {
    _justificativaController.dispose();
    super.dispose();
  }

  Future<void> _carregarSecretarias() async {
    await _secretariaViewModel.carregarSecretarias();

    if (!mounted) return;

    setState(() {
      _secretarias = _secretariaViewModel.secretarias
          .where(
            (secretaria) => secretaria.id != widget.patrimonio.secretariaId,
          )
          .toList();

      _carregandoSecretarias = _secretariaViewModel.carregando;
      _erroSecretarias = _secretariaViewModel.erro ?? '';
    });
  }

  Future<void> _aoEscolherSecretaria(String? secretariaId) async {
    setState(() {
      _secretariaDestinoId = secretariaId;
    });

    if (secretariaId == null) return;

    if (!mounted) return;

    final erro = _salaViewModel.erro;
    if (erro != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar salas: $erro')));
    }
  }

  Future<void> _confirmar() async {
    final justificativa = _justificativaController.text.trim();

    String? mensagemErro;

    if (_secretariaDestinoId == null) {
      mensagemErro = 'Selecione a nova secretaria.';
    } else if (_motivoSelecionado == null) {
      mensagemErro = 'Selecione o motivo da transferência.';
    } else if (justificativa.length < 10) {
      mensagemErro = 'Escreva uma justificativa com pelo menos 10 caracteres.';
    }

    if (mensagemErro != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensagemErro)));
      return;
    }

    setState(() {
      _enviando = true;
    });

    try {
      await _movimentacaoViewModel.criarTransferencia(
        patrimonioId: widget.patrimonio.id ?? '',
        secretariaDestinoId: _secretariaDestinoId!,
        motivo: _motivoSelecionado!,
        justificativa: justificativa,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Transferência enviada. Aguardando recebimento pela secretaria de destino.',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        _enviando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.fundo,
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
                      'Transferência do Patrimônio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _cardPatrimonio(),
                    const SizedBox(height: 20),

                    _titulo('Localização da Transferência'),
                    const SizedBox(height: 8),
                    _cardOrigem(),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppCores.azulClaro,
                          child: Icon(
                            Icons.swap_vert,
                            color: AppCores.azulEscuro,
                          ),
                        ),
                      ),
                    ),

                    _cardDestino(),
                    const SizedBox(height: 20),

                    _titulo('Motivo da Transferência'),
                    const Text(
                      'Selecione o motivo e escreva a justificativa',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppCores.textoSecundario,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Chips de motivo
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        for (final motivo in _motivos)
                          ChoiceChip(
                            label: Text(motivo),
                            selected: _motivoSelecionado == motivo,
                            onSelected: (selecionado) {
                              setState(() {
                                _motivoSelecionado = selecionado
                                    ? motivo
                                    : null;
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    TextField(
                      controller: _justificativaController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Escreva a justificativa da movimentação...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // BOTÕES
                    ElevatedButton(
                      onPressed: _enviando ? null : _confirmar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppCores.azul,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _enviando
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Confirmar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppCores.azul),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  // PARTES DA TELA

  Widget _titulo(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppCores.texto,
      ),
    );
  }

  // Número + descrição do patrimônio
  Widget _cardPatrimonio() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppCores.azulClaro,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.patrimonio.numeroPatrimonio,
              style: const TextStyle(
                fontSize: 12,
                color: AppCores.azulEscuro,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.patrimonio.descricao,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // Origem atual (bloqueada, em cinza)
  Widget _cardOrigem() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.lock_outline,
                size: 16,
                color: AppCores.textoSecundario,
              ),
              SizedBox(width: 6),
              Text(
                'Origem atual',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppCores.textoSecundario,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _linhaIcone(Icons.apartment, widget.patrimonio.secretaria),
          const SizedBox(height: 4),
          _linhaIcone(Icons.meeting_room_outlined, widget.patrimonio.sala),
        ],
      ),
    );
  }

  Widget _linhaIcone(IconData icone, String texto) {
    return Row(
      children: [
        Icon(icone, size: 16, color: AppCores.textoSecundario),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(
              fontSize: 13,
              color: AppCores.textoSecundario,
            ),
          ),
        ),
      ],
    );
  }

  // Novo destino (secretaria + sala)
  Widget _cardDestino() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppCores.azul),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on, size: 16, color: AppCores.azulEscuro),
              SizedBox(width: 6),
              Text(
                'Novo destino',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppCores.azulEscuro,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // SECRETARIA
          if (_secretariaViewModel.carregando)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_secretariaViewModel.erro != null)
            Text(
              _secretariaViewModel.erro!,
              style: const TextStyle(color: AppCores.vermelho),
            )
          else
            DropdownButtonFormField<String>(
              initialValue: _secretariaDestinoId,
              isExpanded: true,
              decoration: _decoracaoCampo('Nova Secretaria / Setor'),
              hint: const Text('Selecione a secretaria'),
              items: _secretarias
                  .map(
                    (secretaria) => DropdownMenuItem<String>(
                      value: secretaria.id,
                      child: Text(secretaria.nome),
                    ),
                  )
                  .toList(),
              onChanged: _aoEscolherSecretaria,
            ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  InputDecoration _decoracaoCampo(String rotulo) {
    return InputDecoration(
      labelText: rotulo,
      filled: true,
      fillColor: AppCores.fundo,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
