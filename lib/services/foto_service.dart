import 'dart:typed_data';

import 'package:projeto_inventario_patrimonial_frontend/data/network/api_requester.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/foto.dart';

/// Chamadas da API de fotos (rotas /arquivos).
class FotoService {
  final ApiRequester _requester;

  FotoService({ApiRequester? requester})
    : _requester = requester ?? ApiRequester();

  /// GET /arquivos/patrimonio/:patrimonioId -> lista das fotos (principal primeiro)
  Future<List<Foto>> listarFotos(String patrimonioId) async {
    final dados = await _requester.get('/arquivos/patrimonio/$patrimonioId');

    if (dados is! List) {
      throw Exception('A API retornou a lista de fotos em formato inválido.');
    }

    return dados
        .map<Foto>((item) => Foto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// GET /arquivos/:id -> bytes da imagem
  Future<Uint8List> baixarFoto(String fotoId) {
    return _requester.getBytes('/arquivos/$fotoId');
  }

  /// POST /arquivos/patrimonio/:patrimonioId (form-data, campo "foto")
  Future<void> enviarFoto({
    required String patrimonioId,
    required Uint8List bytes,
    required String nomeArquivo,
    required String tipoConteudo,
  }) async {
    await _requester.enviarArquivo(
      '/arquivos/patrimonio/$patrimonioId',
      campo: 'foto',
      bytes: bytes,
      nomeArquivo: nomeArquivo,
      tipoConteudo: tipoConteudo,
    );
  }

  /// PATCH /arquivos/:id/principal
  Future<void> definirPrincipal(String fotoId) async {
    await _requester.patch('/arquivos/$fotoId/principal', dados: {});
  }

  /// DELETE /arquivos/:id
  Future<void> excluirFoto(String fotoId) async {
    await _requester.delete('/arquivos/$fotoId');
  }
}
