import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/widgets/patrimonio_card.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final todosPatrimonios = Patrimonio.patrimonioMock;

    // Define quantos serão exibidos na Home.
    final limiteExibicao = 3;

    // Prepara a lista limitada.
    final listaExibida = todosPatrimonios.take(limiteExibicao).toList();

    final _pages = [
      //0 - Início
      Column(
        children: [
          // ÁREA SUPERIOR FIXA
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Botão escanear
                ElevatedButton(
                  onPressed: () {
                    // Abrir scanner
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ScannerPreviewPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.qr_code_scanner, size: 28),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Escanear Patrimônio',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Aponte para o código de barras ou qrcode',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),

                // Busca + botão filtro
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar por nome, patrimônio ou cód...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune, color: Colors.black54),
                        onPressed: () {
                          _abrirFiltro(context);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Contagem e ordenação
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${listaExibida.length} itens encontrados',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Row(
                      children: [
                        Text('Ordenar: ', style: TextStyle(color: Colors.grey)),
                        Text(
                          'Recentes',
                          style: TextStyle(
                            color: Color(0xFF1E3A8A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF1E3A8A),
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // LISTA ROLÁVEL
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16.0),
              itemCount: listaExibida.length,
              itemBuilder: (context, index) {
                return PatrimonioCard(patrimonio: listaExibida[index]);
              },
            ),
          ),
        ],
      ),
      const SizedBox.shrink(),
      //2 - Inventário
      const Center(child: Text('Conteúdo da página inventário')),

      //3 - Perfil
      // const Center(child: Text('Conteúdo da página perfil')),
      const ProfilePage(),
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

  void _abrirFiltro(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtrar patrimônios',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Sala',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'lab_informatica',
                    child: Text('Lab. Informática'),
                  ),
                  DropdownMenuItem(
                    value: 'secretaria',
                    child: Text('Secretaria'),
                  ),
                  DropdownMenuItem(
                    value: 'lab_redes',
                    child: Text('Lab. Redes'),
                  ),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'em_uso', child: Text('Em uso')),
                  DropdownMenuItem(
                    value: 'disponivel',
                    child: Text('Disponível'),
                  ),
                  DropdownMenuItem(
                    value: 'manutencao',
                    child: Text('Em manutenção'),
                  ),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Limpar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Aplicar filtros na lista
                      },
                      child: const Text('Aplicar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
