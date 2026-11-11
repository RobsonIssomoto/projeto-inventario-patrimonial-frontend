import 'package:dio/dio.dart';

import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';
import 'package:projeto_inventario_patrimonial_frontend/services/api_config.dart';

class PatrimonioService {
  Future<List<Patrimonio>> listarPatrimonios() async {
    final cabecalhos = await cabecalhosComToken();

    try {
      final resposta = await dio.get<dynamic>(
        '/patrimonios',
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
          .map<Patrimonio>(
            (item) => Patrimonio.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      final codigo = e.response?.statusCode;

      if (codigo == 401) {
        throw Exception('Sua sessão não é válida. Entre novamente.');
      }

      if (codigo == 403) {
        throw Exception(
          'Você não possui permissão para consultar os patrimônios.',
        );
      }

      throw Exception(
        'Não foi possível carregar os patrimônios '
        '(HTTP ${codigo ?? 'desconhecido'}).',
      );
    }
  }

  Future<void> atualizarPatrimonio({
    required String id,
    required String status,
    required String estadoConservacao,
    required String observacoes,
  }) async {
    final cabecalhos = await cabecalhosComToken();

    try {
      await dio.patch(
        '/patrimonios/$id',
        options: Options(headers: cabecalhos),
        data: {
          'status': status,
          'estadoConservacao': estadoConservacao,
          'observacoes': observacoes,
        },
      );
    } on DioException catch (e) {
      final codigo = e.response?.statusCode;
      final dados = e.response?.data;

      if (codigo == 400 && dados is Map && dados['erro'] is String) {
        throw Exception(dados['erro']);
      }

      if (codigo == 401) {
        throw Exception('Sua sessão não é válida. Entre novamente.');
      }

      if (codigo == 403) {
        throw Exception(
          'Você não possui permissão para alterar este patrimônio.',
        );
      }

      if (codigo == 404) {
        throw Exception('Patrimônio não encontrado.');
      }

      throw Exception(
        'Não foi possível salvar o patrimônio.'
        '(HTTP ${codigo ?? 'desconhecido'}).',
      );
    }
  }
}
