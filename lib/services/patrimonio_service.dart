import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';

class PatrimonioService {
  static const String baseUrl = 'http://localhost:3000/api/v1';

  Future<List<Patrimonio>> listarPatrimonios() async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não autenticado. Entre novamente.');
    }

    final token = await usuario.getIdToken();

    if (token == null || token.isEmpty) {
      throw Exception('Não foi possível validar sua sessão.');
    }

    final resposta = await http
        .get(
          Uri.parse('$baseUrl/patrimonios'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 15));

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(utf8.decode(resposta.bodyBytes));

      final List lista;

      if (dados is List) {
        lista = dados;
      } else if (dados is Map && dados['dados'] is List) {
        lista = dados['dados'] as List;
      } else if (dados is Map && dados['data'] is List) {
        lista = dados['data'] as List;
      } else {
        throw Exception('A API retornou uma lista em formato inválido.');
      }

      return lista
          .map<Patrimonio>(
            (item) => Patrimonio.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    }

    if (resposta.statusCode == 401) {
      throw Exception('Sua sessão não é válida. Entre novamente.');
    }

    if (resposta.statusCode == 403) {
      throw Exception(
        'Você não possui permissão para consultar os patrimônios.',
      );
    }

    throw Exception(
      'Não foi possível carregar os patrimônios '
      '(HTTP ${resposta.statusCode}).',
    );
  }
}
