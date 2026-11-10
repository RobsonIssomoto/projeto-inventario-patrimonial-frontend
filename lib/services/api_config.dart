import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String apiBaseUrl = 'http://localhost:3000/api/v1';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ),
);

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
