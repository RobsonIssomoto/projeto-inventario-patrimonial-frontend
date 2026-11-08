import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:projeto_inventario_patrimonial_frontend/models/secretaria.dart';
import 'package:projeto_inventario_patrimonial_frontend/services/api_config.dart';

class SecretariaService {
  /// Lista as secretarias ativas.
  Future<List<Secretaria>> listarSecretarias() async {
    final cabecalhos = await cabecalhosComToken();

    final resposta = await http
        .get(Uri.parse('$apiBaseUrl/secretarias'), headers: cabecalhos)
        .timeout(const Duration(seconds: 15));

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(utf8.decode(resposta.bodyBytes));

      if (dados is! List) {
        throw Exception('A API retornou as secretarias em formato inválido.');
      }

      return dados
          .map<Secretaria>(
            (item) => Secretaria.fromJson(item as Map<String, dynamic>),
          )
          .where((secretaria) => secretaria.ativa) // só as ativas
          .toList();
    }

    if (resposta.statusCode == 401) {
      throw Exception('Sua sessão não é válida. Entre novamente.');
    }

    throw Exception(
      'Não foi possível carregar as secretarias '
      '(HTTP ${resposta.statusCode}).',
    );
  }
}
