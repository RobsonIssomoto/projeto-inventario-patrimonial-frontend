import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/cores.dart';

import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';
import 'package:projeto_inventario_patrimonial_frontend/viewmodels/inventario_viewmodel.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/patrimonio_detail.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/widgets/patrimonio_card_sm.dart';

class InventarioPage extends StatefulWidget {
  const InventarioPage({super.key, required this.onVoltar});

  final VoidCallback onVoltar;

  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  final InventarioViewModel _viewModel = InventarioViewModel();

  final TextEditingController _buscaController = TextEditingController();

  List<Patrimonio> _patrimoniosExibidos = [];

  String? _salaSelecionada;
  String? _categoriaSelecionada;
  String _ordenarPor = 'descricao';

  bool _carregando = true;
  String _erro = '';

  @override
  void initState() {
    super.initState();
    _carregarPatrimonios();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarPatrimonios() async {
    if (!mounted) return;

    setState(() {
      _carregando = true;
      _erro = '';
    });

    try {
      await _viewModel.carregarPatrimonios();

      if (!mounted) return;

      final salas = _viewModel.listarSalas();
      final categorias = _viewModel.listarCategorias();

      if (!salas.contains(_salaSelecionada)) {
        _salaSelecionada = null;
      }

      if (!categorias.contains(_categoriaSelecionada)) {
        _categoriaSelecionada = null;
      }

      setState(() {
        _patrimoniosExibidos = _viewModel.buscarPatrimonios(
          busca: _buscaController.text,
          sala: _salaSelecionada,
          categoria: _categoriaSelecionada,
          ordenarPor: _ordenarPor,
        );

        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      final mensagem = e.toString();

      setState(() {
        _carregando = false;

        _erro = mensagem.startsWith('Exception: ')
            ? mensagem.substring('Exception: '.length)
            : 'Não foi possível carregar os patrimônios. '
                  'Verifique a conexão e tente novamente.';
      });
    }
  }

  void _atualizarLista() {
    setState(() {
      _patrimoniosExibidos = _viewModel.buscarPatrimonios(
        busca: _buscaController.text,
        sala: _salaSelecionada,
        categoria: _categoriaSelecionada,
        ordenarPor: _ordenarPor,
      );
    });
  }

  void _limparBusca() {
    _buscaController.clear();
    _atualizarLista();
  }

  void _limparFiltros() {
    _salaSelecionada = null;
    _categoriaSelecionada = null;

    _atualizarLista();
  }

  Future<void> _abrirFiltros() async {
    FocusScope.of(context).unfocus();

    final salas = _viewModel.listarSalas();
    final categorias = _viewModel.listarCategorias();

    String? salaTemporaria = _salaSelecionada;
    String? categoriaTemporaria = _categoriaSelecionada;

    final aplicar = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Filtrar patrimônios',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppCores.azulEscuro,
                  ),
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  initialValue: salaTemporaria,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Sala',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Todas as salas'),
                    ),
                    ...salas.map(
                      (sala) => DropdownMenuItem<String>(
                        value: sala,
                        child: Text(sala),
                      ),
                    ),
                  ],
                  onChanged: (valor) {
                    salaTemporaria = valor;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: categoriaTemporaria,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Todas as categorias'),
                    ),
                    ...categorias.map(
                      (categoria) => DropdownMenuItem<String>(
                        value: categoria,
                        child: Text(categoria),
                      ),
                    ),
                  ],
                  onChanged: (valor) {
                    categoriaTemporaria = valor;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Aplicar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || aplicar != true) return;

    _salaSelecionada = salaTemporaria;
    _categoriaSelecionada = categoriaTemporaria;

    _atualizarLista();
  }

  Widget _buildLista() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro.isNotEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_outlined,
                size: 40,
                color: AppCores.textoSecundario,
              ),
              const SizedBox(height: 16),
              Text(
                _erro,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppCores.textoSecundario,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _carregarPatrimonios,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_patrimoniosExibidos.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Nenhum patrimônio encontrado.\n'
            'Se houver busca ou filtros ativos, tente alterá-los.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppCores.textoSecundario),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _patrimoniosExibidos.length,
      itemBuilder: (context, index) {
        final patrimonio = _patrimoniosExibidos[index];

        return PatrimonioCardSm(
          patrimonio: patrimonio,
          onTap: () async {
            FocusScope.of(context).unfocus();

            // A tela de detalhes devolve true quando o patrimônio foi salvo
            final salvou = await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (context) => PatrimonioDetail(patrimonio: patrimonio),
              ),
            );

            // Recarrega a lista para mostrar os dados atualizados
            if (salvou == true) {
              _carregarPatrimonios();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final temFiltro = _salaSelecionada != null || _categoriaSelecionada != null;

    final podeConsultar = !_carregando && _erro.isEmpty;

    final String textoContagem;

    if (_carregando) {
      textoContagem = 'Carregando patrimônios...';
    } else if (_erro.isNotEmpty) {
      textoContagem = 'Consulta indisponível';
    } else if (_patrimoniosExibidos.length == 1) {
      textoContagem = '1 patrimônio encontrado';
    } else {
      textoContagem = '${_patrimoniosExibidos.length} patrimônios encontrados';
    }

    return Scaffold(
      backgroundColor: AppCores.fundo,
      appBar: AppBar(
        backgroundColor: AppCores.fundo,
        foregroundColor: AppCores.azulEscuro,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: const Text(
          'Inventário',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _buscaController,
                      enabled: podeConsultar,
                      onChanged: (_) {
                        _atualizarLista();
                      },
                      decoration: InputDecoration(
                        hintText: 'Descrição ou número',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _buscaController.text.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Limpar busca',
                                onPressed: podeConsultar ? _limparBusca : null,
                                icon: const Icon(Icons.close),
                              ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Filtrar patrimônios',
                    onPressed: podeConsultar ? _abrirFiltros : null,
                    icon: Icon(
                      Icons.tune,
                      color: !podeConsultar
                          ? AppCores.desabilitado
                          : temFiltro
                          ? AppCores.azul
                          : AppCores.textoSecundario,
                    ),
                  ),
                ],
              ),
            ),
            if (temFiltro)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (_salaSelecionada != null)
                      Chip(label: Text('Sala: $_salaSelecionada')),
                    if (_categoriaSelecionada != null)
                      Chip(label: Text(_categoriaSelecionada!)),
                    TextButton(
                      onPressed: podeConsultar ? _limparFiltros : null,
                      child: const Text('Limpar filtros'),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      textoContagem,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppCores.textoSecundario,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    enabled: podeConsultar,
                    tooltip: 'Ordenar patrimônios',
                    initialValue: _ordenarPor,
                    onSelected: (valor) {
                      _ordenarPor = valor;
                      _atualizarLista();
                    },
                    itemBuilder: (context) => [
                      CheckedPopupMenuItem<String>(
                        value: 'descricao',
                        checked: _ordenarPor == 'descricao',
                        child: const Text('Descrição: A–Z'),
                      ),
                      CheckedPopupMenuItem<String>(
                        value: 'numero',
                        checked: _ordenarPor == 'numero',
                        child: const Text('Número patrimonial'),
                      ),
                    ],
                    icon: Icon(
                      Icons.sort,
                      color: podeConsultar
                          ? AppCores.azulEscuro
                          : AppCores.desabilitado,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildLista()),
          ],
        ),
      ),
    );
  }
}
