import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';
import 'package:projeto_inventario_patrimonial_frontend/services/api_config.dart';

class PatrimonioService {
  Future<List<Patrimonio>> listarPatrimonios() async {
    final cabecalhos = await cabecalhosComToken();

    final resposta = await http
        .get(Uri.parse('$apiBaseUrl/patrimonios'), headers: cabecalhos)
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

  /// Salva o resultado da conferência (status, estado e observações).
  Future<void> atualizarPatrimonio({
    required String id,
    required String status,
    required String estadoConservacao,
    required String observacoes,
  }) async {
    final cabecalhos = await cabecalhosComToken();

    final resposta = await http
        .patch(
          Uri.parse('$apiBaseUrl/patrimonios/$id'),
          headers: cabecalhos,
          body: jsonEncode({
            'status': status,
            'estadoConservacao': estadoConservacao,
            'observacoes': observacoes,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (resposta.statusCode == 200) return;

    //a API explica o problema no campo "erro"
    if (resposta.statusCode == 400) {
      final dados = jsonDecode(utf8.decode(resposta.bodyBytes));
      throw Exception(dados['erro'] ?? 'Dados inválidos.');
    }

    if (resposta.statusCode == 401) {
      throw Exception('Sua sessão não é válida. Entre novamente.');
    }

    if (resposta.statusCode == 403) {
      throw Exception(
        'Você não possui permissão para alterar este patrimônio.',
      );
    }

    if (resposta.statusCode == 404) {
      throw Exception('Patrimônio não encontrado.');
    }

    throw Exception(
      'Não foi possível salvar o patrimônio (HTTP ${resposta.statusCode}).',
    );
  }
}
