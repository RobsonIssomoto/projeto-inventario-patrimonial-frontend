import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/cores.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/inicio_page.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/inventario_page.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/profile_page.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/scanner_page.dart';
import 'package:projeto_inventario_patrimonial_frontend/viewmodels/perfil_viewmodel.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/recebimentos_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PerfilViewModel _perfilViewModel = PerfilViewModel();
  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    if (_perfilViewModel.carregando) return;

    final operacao = _perfilViewModel.carregar();

    setState(() {});

    await operacao;

    if (!mounted) return;

    setState(() {});
  }

  void _abrirRecebimentos() {
    if (!_perfilViewModel.podeReceberTransferencias) return;

    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const RecebimentosPage()));
  }

  static const int _abaInicio = 0;
  static const int _abaScanner = 1;
  static const int _abaInventario = 2;

  int _selectedIndex = _abaInicio;

  void _abrirScanner() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ScannerPreviewPage()));
  }

  void _irParaAba(int aba) {
    setState(() {
      _selectedIndex = aba;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      // 0 - Início
      InicioPage(
        onEscanear: _abrirScanner,
        onAbrirInventario: () => _irParaAba(_abaInventario),
        onAbrirRecebimentos: _abrirRecebimentos,
        podeReceberTransferencias: _perfilViewModel.podeReceberTransferencias,
        carregandoPerfil: _perfilViewModel.carregando,
        erroPerfil: _perfilViewModel.erro,
        onTentarCarregarPerfil: _carregarPerfil,
      ),

      // 1 - Scanner abre em uma tela separada.
      const SizedBox.shrink(),

      // 2 - Inventário
      InventarioPage(onVoltar: () => _irParaAba(_abaInicio)),

      // 3 - Perfil
      ProfilePage(onVoltar: () => _irParaAba(_abaInicio)),
    ];

    return Scaffold(
      backgroundColor: AppCores.fundo,

      //  CONTEÚDO PRINCIPAL
      body: pages[_selectedIndex],

      //  BARRA DE NAVEGAÇÃO INFERIOR
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          // Scanner abre separado e não muda a aba atual.
          if (index == _abaScanner) {
            _abrirScanner();
            return;
          }

          // Início, Inventário e Perfil trocam o body.
          _irParaAba(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code_outlined),
            label: 'Scanner',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Inventário',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
