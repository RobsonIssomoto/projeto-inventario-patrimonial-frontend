import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/profile_page.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/inventario_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final _pages = [
      // 0 - Início
      SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            const Text(
              'Início',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Consulte seus patrimônios',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Escaneie a etiqueta para identificar um bem '
              'e acessar seus dados.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 48),
            const Center(
              child: CircleAvatar(
                radius: 64,
                backgroundColor: Color(0xFFDBEAFE),
                child: Icon(
                  Icons.qr_code_scanner,
                  size: 64,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ScannerPreviewPage()),
                );
              },
              icon: const Icon(Icons.qr_code_scanner, size: 24),
              label: const Text(
                'Escanear patrimônio',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(0, 56),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'Consultar inventário',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // 1 - Scanner abre em uma tela separada.
      const SizedBox.shrink(),

      // 2 - Inventário
      InventarioPage(
        onVoltar: () {
          setState(() {
            _selectedIndex = 0;
          });
        },
      ),

      // 3 - Perfil
      ProfilePage(
        onVoltar: () {
          setState(() {
            _selectedIndex = 0;
          });
        },
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F9),

      //  CONTEÚDO PRINCIPAL
      body: _pages[_selectedIndex],

      //  BARRA DE NAVEGAÇÃO INFERIOR
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          // Scanner abre separado e não muda a aba atual.
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ScannerPreviewPage(),
              ),
            );

            return;
          }

          // Início, Inventário e Perfil trocam o body.
          setState(() {
            _selectedIndex = index;
          });
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

class ScannerPreviewPage extends StatelessWidget {
  const ScannerPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: IconButton(
                    tooltip: 'Voltar',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Área da câmera',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
