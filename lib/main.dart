import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/cores.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

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
      title: 'Inventário Patrimonial',

      // TEMA DO APP
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppCores.azul,
          primary: AppCores.azul,
        ),
        scaffoldBackgroundColor: AppCores.fundo,

        // Fundo do item selecionado na barra de navegação inferior.
        navigationBarTheme: const NavigationBarThemeData(
          indicatorColor: AppCores.azulClaro,
        ),
      ),

      // A splash decide se abre o Login ou a Home.
      home: const SplashPage(),
    );
  }
}
