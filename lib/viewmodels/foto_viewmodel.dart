import 'dart:typed_data';

import 'package:projeto_inventario_patrimonial_frontend/models/foto.dart';
import 'package:projeto_inventario_patrimonial_frontend/repositories/foto_repository.dart';

/// ViewModel das fotos de um patrimônio.
///
/// Segue o mesmo padrão dos outros ViewModels do app:
/// guarda o estado (lista, carregando, erro) e chama o repositório.
/// A tela lê os getters e chama setState depois de cada ação.
class FotoViewModel {
  /// Regra de negócio (a API confere a mesma regra).
  static const int limiteFotos = 3;

  /// Tipos de imagem aceitos pela API.
  static const List<String> tiposAceitos = [
    'image/jpeg',
    'image/png',
    'image/webp',
  ];

  final FotoRepository _repository;

  FotoViewModel({FotoRepository? repository})
    : _repository = repository ?? FotoRepository();

  List<Foto> _fotos = [];
  bool _carregando = false;
  bool _enviando = false;
  String? _erro;

  List<Foto> get fotos => List.unmodifiable(_fotos);
  bool get carregando => _carregando;
  bool get enviando => _enviando;
  String? get erro => _erro;

  /// true enquanto ainda cabe mais uma foto
  bool get podeAdicionar => _fotos.length < limiteFotos;

  /// Busca as fotos do patrimônio na API.
  Future<void> carregar(String patrimonioId) async {
    _carregando = true;
    _erro = null;

    try {
      _fotos = await _repository.listarFotos(patrimonioId);
    } catch (erro) {
      _erro = _mensagem(erro);
    } finally {
      _carregando = false;
    }
  }

  /// Envia uma foto e recarrega a lista.
  /// Lança Exception com mensagem amigável se algo der errado.
  Future<void> enviar({
    required String patrimonioId,
    required Uint8List bytes,
    required String nomeArquivo,
    required String tipoConteudo,
  }) async {
    if (!podeAdicionar) {
      throw Exception('Limite de $limiteFotos fotos por patrimônio atingido.');
    }

    if (!tiposAceitos.contains(tipoConteudo)) {
      throw Exception('Formato inválido. Use uma imagem JPG, PNG ou WEBP.');
    }

    _enviando = true;

    try {
      await _repository.enviarFoto(
        patrimonioId: patrimonioId,
        bytes: bytes,
        nomeArquivo: nomeArquivo,
        tipoConteudo: tipoConteudo,
      );
    } finally {
      _enviando = false;
    }

    await carregar(patrimonioId);
  }

  Future<void> definirPrincipal({
    required String patrimonioId,
    required String fotoId,
  }) async {
    await _repository.definirPrincipal(fotoId);
    await carregar(patrimonioId);
  }

  Future<void> excluir({
    required String patrimonioId,
    required String fotoId,
  }) async {
    await _repository.excluirFoto(fotoId);
    await carregar(patrimonioId);
  }

  /// Bytes da imagem (o repositório guarda em cache).
  Future<Uint8List> baixarFoto(String fotoId) {
    return _repository.baixarFoto(fotoId);
  }

  /// Descobre o tipo da imagem: primeiro pelo que o sistema informa,
  /// depois pela extensão do nome do arquivo. null = formato não aceito.
  String? tipoDaImagem({String? tipoInformado, required String nomeArquivo}) {
    if (tipoInformado != null && tipoInformado.startsWith('image/')) {
      return tiposAceitos.contains(tipoInformado) ? tipoInformado : null;
    }

    final nome = nomeArquivo.toLowerCase();
    if (nome.endsWith('.png')) return 'image/png';
    if (nome.endsWith('.webp')) return 'image/webp';
    if (nome.endsWith('.jpg') || nome.endsWith('.jpeg')) return 'image/jpeg';
    return null;
  }

  String _mensagem(Object erro) {
    return erro.toString().replaceFirst('Exception: ', '');
  }
}
