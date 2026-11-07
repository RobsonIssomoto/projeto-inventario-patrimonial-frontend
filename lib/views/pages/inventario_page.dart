import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();

    _patrimoniosExibidos = _viewModel.buscarPatrimonios();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
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
                    color: Color(0xFF1E3A8A),
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

  @override
  Widget build(BuildContext context) {
    final temFiltro = _salaSelecionada != null || _categoriaSelecionada != null;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEEF2F9),
        foregroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          tooltip: 'Voltar ao início',
          onPressed: widget.onVoltar,
          icon: const Icon(Icons.arrow_back),
        ),
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
                                onPressed: _limparBusca,
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
                    onPressed: _abrirFiltros,
                    icon: Icon(
                      Icons.tune,
                      color: temFiltro
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF64748B),
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
                      onPressed: _limparFiltros,
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
                      _patrimoniosExibidos.length == 1
                          ? '1 patrimônio encontrado'
                          : '${_patrimoniosExibidos.length} '
                                'patrimônios encontrados',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
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
                    icon: const Icon(Icons.sort, color: Color(0xFF1E3A8A)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _patrimoniosExibidos.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Nenhum patrimônio encontrado.\n'
                          'Tente outra busca ou limpe os filtros.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: _patrimoniosExibidos.length,
                      itemBuilder: (context, index) {
                        final patrimonio = _patrimoniosExibidos[index];

                        return PatrimonioCardSm(
                          patrimonio: patrimonio,
                          onTap: () {
                            FocusScope.of(context).unfocus();

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PatrimonioDetail(patrimonio: patrimonio),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
