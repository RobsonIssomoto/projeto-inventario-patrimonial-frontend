import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/home_page.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Página Inicial - APP Inventário Patrimônial",
      home: LoginPage(), // Chama a página estruturada
    );
  }
}
