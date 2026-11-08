import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:projeto_inventario_patrimonial_frontend/models/sala.dart';
import 'package:projeto_inventario_patrimonial_frontend/services/api_config.dart';

class SalaService {
  /// Lista as salas ativas de uma secretaria.
  Future<List<Sala>> listarSalasDaSecretaria(String secretariaId) async {
    final cabecalhos = await cabecalhosComToken();

    final resposta = await http
        .get(
          Uri.parse('$apiBaseUrl/salas?secretaria=$secretariaId&ativa=true'),
          headers: cabecalhos,
        )
        .timeout(const Duration(seconds: 15));

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(utf8.decode(resposta.bodyBytes));

      if (dados is! List) {
        throw Exception('A API retornou as salas em formato inválido.');
      }

      return dados
          .map<Sala>((item) => Sala.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    if (resposta.statusCode == 401) {
      throw Exception('Sua sessão não é válida. Entre novamente.');
    }

    throw Exception(
      'Não foi possível carregar as salas (HTTP ${resposta.statusCode}).',
    );
  }
}
