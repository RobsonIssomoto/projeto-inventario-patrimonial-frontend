import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/widgets/patrimonio_card.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final listaPatrimonios = Patrimonio.patrimonioMock;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Página Inicial - APP Inventário Patrimônial",
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Início'),
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          itemCount: listaPatrimonios.length,
          itemBuilder: (context, index) {
            final item = listaPatrimonios[index];
            return PatrimonioCard(patrimonio: item);
          },
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF2563EB)),
                accountName: Text(
                  "Nome do usuário",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  "usuario@email.com",
                  style: TextStyle(color: Colors.white70),
                ),
                currentAccountPicture: CircleAvatar(
                  child: Text(
                    "U",
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Início"),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
