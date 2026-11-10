import 'package:dio/dio.dart';

import 'package:projeto_inventario_patrimonial_frontend/models/secretaria.dart';
import 'package:projeto_inventario_patrimonial_frontend/services/api_config.dart';

class SecretariaService {
  Future<List<Secretaria>> listarSecretarias() async {
    final cabecalhos = await cabecalhosComToken();

    try {
      final resposta = await dio.get<dynamic>(
        '/secretarias',
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
          .map<Secretaria>(
            (item) => Secretaria.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      final codigo = e.response?.statusCode;

      if (codigo == 401) {
        throw Exception('Sua sessão não é válida. Entre novamente.');
      }

      if (codigo == 403) {
        throw Exception(
          'Você não possui permissão para consultar as secretarias.',
        );
      }

      throw Exception(
        'Não foi possível carregar as secretarias '
        '(HTTP ${codigo ?? 'desconhecido'}).',
      );
    }
  }

  // Future<void> atualizarSecretaria({
  //   required String id,
  //   required String nome,
  //   required String sigla,
  //   required String telefone,
  //   required String email,
  // }) async {
  //   final cabecalhos = await cabecalhosComToken();

  //   try {
  //     await dio.put(
  //       '/secretarias/$id',
  //       options: Options(headers: cabecalhos),
  //       data: {
  //         'nome': nome,
  //         'sigla': sigla,
  //         'telefone': telefone,
  //         'email': email,
  //       },
  //     );
  //   } on DioException catch (e) {
  //     final codigo = e.response?.statusCode;

  //     if (codigo == 401) {
  //       throw Exception('Sua sessão não é válida. Entre novamente.');
  //     }

  //     if (codigo == 403) {
  //       throw Exception(
  //         'Você não possui permissão para atualizar a secretaria.',
  //       );
  //     }

  //     throw Exception(
  //       'Não foi possível atualizar a secretaria '
  //       '(HTTP ${codigo ?? 'desconhecido'}).',
  //     );
  //   }
  // }
}
