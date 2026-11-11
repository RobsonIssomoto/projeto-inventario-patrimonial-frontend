import 'package:dio/dio.dart';

import 'package:projeto_inventario_patrimonial_frontend/services/api_config.dart';

///Camada responsável por fazer requisições HTTP para a API, incluindo o token de autenticação do Firebase.
class ApiRequester {
  Future<dynamic> get(String caminho) async {
    final cabecalhos = await cabecalhosComToken();

    try {
      final resposta = await dio.get<dynamic>(
        caminho,
        options: Options(headers: cabecalhos),
      );

      return _extrairDados(resposta);
    } on DioException catch (erro) {
      throw _traduzirErro(erro);
    }
  }

  Future<dynamic> post(
    String caminho, {
    required Map<String, dynamic> dados,
  }) async {
    final cabecalhos = await cabecalhosComToken();

    try {
      final resposta = await dio.post<dynamic>(
        caminho,
        data: dados,
        options: Options(headers: cabecalhos),
      );
      return _extrairDados(resposta);
    } on DioException catch (erro) {
      throw _traduzirErro(erro);
    }
  }

  Future<dynamic> put(
    String caminho, {
    required Map<String, dynamic> dados,
  }) async {
    final cabecalhos = await cabecalhosComToken();

    try {
      final resposta = await dio.put<dynamic>(
        caminho,
        data: dados,
        options: Options(headers: cabecalhos),
      );

      return _extrairDados(resposta);
    } on DioException catch (erro) {
      throw _traduzirErro(erro);
    }
  }

  Future<dynamic> delete(String caminho) async {
    final cabecalhos = await cabecalhosComToken();

    try {
      final resposta = await dio.delete<dynamic>(
        caminho,
        options: Options(headers: cabecalhos),
      );

      return _extrairDados(resposta);
    } on DioException catch (erro) {
      throw _traduzirErro(erro);
    }
  }

  dynamic _extrairDados(Response<dynamic> resposta) {
    return resposta.data;
  }

  Exception _traduzirErro(DioException erro) {
    final codigo = erro.response?.statusCode;

    if (codigo == 401) {
      return Exception('Sua sessão não é válida. Entre novamente.');
    }

    if (codigo == 403) {
      return Exception('Você não possui permissão para esta ação.');
    }

    if (codigo == 400) {
      return Exception('Dados inválidos. Verifique as informações enviadas.');
    }

    if (codigo == 404) {
      return Exception('Recurso não encontrado.');
    }

    return Exception(
      'Não foi possível comunicar com o servidor '
      '(HTTP ${codigo ?? 'desconhecido'}).',
    );
  }
}
