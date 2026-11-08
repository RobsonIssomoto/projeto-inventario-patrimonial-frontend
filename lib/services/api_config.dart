import 'package:firebase_auth/firebase_auth.dart';

/// Endereço da API usado por todos os services.
const String apiBaseUrl = 'http://localhost:3000/api/v1';

/// Monta os cabeçalhos das requisições com o token do usuário logado.
///
/// Token fica em um só lugar.
Future<Map<String, String>> cabecalhosComToken() async {
  final usuario = FirebaseAuth.instance.currentUser;

  if (usuario == null) {
    throw Exception('Usuário não autenticado. Entre novamente.');
  }

  final token = await usuario.getIdToken();

  if (token == null || token.isEmpty) {
    throw Exception('Não foi possível validar sua sessão.');
  }

  return {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
}
