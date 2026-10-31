import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/home_page.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/login_page.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/patrimonio_detail.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/alterar_senha_page.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/criar_senha_page.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

// void main() {
//   runApp(const MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Página Inicial - APP Inventário Patrimônial",
      home: HomePage(),
      // const CriarSenhaPage(
      //   oobCode:
      // ),
      // PatrimonioDetail(
      //   patrimonio: Patrimonio.patrimonioMock[0],
      // ), // Chama a página estruturada
    );
  }
}
