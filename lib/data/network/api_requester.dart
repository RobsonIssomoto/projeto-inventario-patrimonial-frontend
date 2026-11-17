import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:projeto_inventario_patrimonial_frontend/services/api_config.dart';

///Camada responsável por fazer requisições HTTP para a API, incluindo o token de autenticação do Firebase.
class ApiRequester {
  Future<dynamic> get(
    String caminho, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final cabecalhos = await cabecalhosComToken();

    try {
      final resposta = await dio.get<dynamic>(
        caminho,
        queryParameters: queryParameters,
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

  Future<dynamic> patch(
    String caminho, {
    required Map<String, dynamic> dados,
  }) async {
    final cabecalhos = await cabecalhosComToken();

    try {
      final resposta = await dio.patch<dynamic>(
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

  /// Baixa um arquivo (ex.: foto) e devolve os bytes.
  /// Usamos bytes + Image.memory porque assim o token vai no cabeçalho
  /// e funciona igual no Chrome, no Android e no iOS.
  Future<Uint8List> getBytes(String caminho) async {
    final cabecalhos = await cabecalhosComToken();

    try {
      final resposta = await dio.get<List<int>>(
        caminho,
        options: Options(headers: cabecalhos, responseType: ResponseType.bytes),
      );

      return Uint8List.fromList(resposta.data ?? []);
    } on DioException catch (erro) {
      throw _traduzirErro(erro);
    }
  }

  /// Envia um arquivo no formato multipart/form-data (o mesmo de um formulário HTML).
  /// [campo] é o nome que a API espera (no nosso caso, "foto").
  Future<dynamic> enviarArquivo(
    String caminho, {
    required String campo,
    required Uint8List bytes,
    required String nomeArquivo,
    required String tipoConteudo,
  }) async {
    final cabecalhos = await cabecalhosComToken();

    // O Dio monta o Content-Type do multipart sozinho (com o "boundary"),
    // então tiramos o "application/json" que vem por padrão.
    cabecalhos.remove('Content-Type');

    final formulario = FormData.fromMap({
      campo: MultipartFile.fromBytes(
        bytes,
        filename: nomeArquivo,
        contentType: DioMediaType.parse(tipoConteudo),
      ),
    });

    try {
      final resposta = await dio.post<dynamic>(
        caminho,
        data: formulario,
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

    if (codigo == 400 || codigo == 409) {
      final dados = erro.response?.data;

      if (dados is Map) {
        final mensagem = dados['erro'] ?? dados['message'];

        if (mensagem is String && mensagem.trim().isNotEmpty) {
          return Exception(mensagem);
        }
      }

      return Exception(
        codigo == 409
            ? 'A operação não pode ser concluída no estado atual. '
                  'Atualize a lista.'
            : 'Dados inválidos. Verifique as informações enviadas.',
      );
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
