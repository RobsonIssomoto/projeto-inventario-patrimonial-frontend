import 'dart:typed_data';

import 'package:projeto_inventario_patrimonial_frontend/models/foto.dart';
import 'package:projeto_inventario_patrimonial_frontend/services/foto_service.dart';

/// Repositório de fotos.
///
/// Além de repassar as chamadas para o FotoService, guarda as imagens já
/// baixadas em memória (cache). Assim, ao rolar a lista de patrimônios,
/// a mesma foto não é baixada de novo a cada vez que o card aparece.
class FotoRepository {
  final FotoService _service;

  // "static" = o cache é compartilhado por todas as telas do app
  static final Map<String, Future<Uint8List>> _cache = {};

  FotoRepository({FotoService? service}) : _service = service ?? FotoService();

  Future<List<Foto>> listarFotos(String patrimonioId) {
    return _service.listarFotos(patrimonioId);
  }

  /// Devolve os bytes da foto, usando o cache quando possível.
  Future<Uint8List> baixarFoto(String fotoId) {
    final emCache = _cache[fotoId];
    if (emCache != null) return emCache;

    // Se o download falhar, tira do cache para tentar de novo depois
    final download = _service.baixarFoto(fotoId).catchError((Object erro) {
      _cache.remove(fotoId);
      return Future<Uint8List>.error(erro);
    });

    _cache[fotoId] = download;
    return download;
  }

  Future<void> enviarFoto({
    required String patrimonioId,
    required Uint8List bytes,
    required String nomeArquivo,
    required String tipoConteudo,
  }) {
    return _service.enviarFoto(
      patrimonioId: patrimonioId,
      bytes: bytes,
      nomeArquivo: nomeArquivo,
      tipoConteudo: tipoConteudo,
    );
  }

  Future<void> definirPrincipal(String fotoId) {
    return _service.definirPrincipal(fotoId);
  }

  Future<void> excluirFoto(String fotoId) async {
    await _service.excluirFoto(fotoId);
    _cache.remove(fotoId);
  }
}
