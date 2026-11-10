import 'package:dio/dio.dart';

import 'package:projeto_inventario_patrimonial_frontend/models/sala.dart';
import 'package:projeto_inventario_patrimonial_frontend/services/api_config.dart';

class SalaService {
  Future<List<Sala>> listarSalas() async {
    final cabecalhos = await cabecalhosComToken();

    try {
      final resposta = await dio.get<dynamic>(
        '/salas',
        options: Options(headers: cabecalhos),
      );

      final dados = resposta.data;

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
          .map<Sala>((item) => Sala.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final codigo = e.response?.statusCode;

      if (codigo == 401) {
        throw Exception('Sua sessão não é válida. Entre novamente.');
      }

      if (codigo == 403) {
        throw Exception('Você não possui permissão para consultar as salas.');
      }

      throw Exception(
        'Não foi possível carregar as salas '
        '(HTTP ${codigo ?? 'desconhecido'}).',
      );
    }
  }
}
