import 'package:projeto_inventario_patrimonial_frontend/data/network/api_requester.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/movimentacao.dart';

class MovimentacaoService {
  final ApiRequester _requester;

  MovimentacaoService({ApiRequester? requester})
    : _requester = requester ?? ApiRequester();

  Future<List<Movimentacao>> listarPorPatrimonio(String patrimonioId) async {
    final dados = await _requester.get(
      '/movimentacoes',
      queryParameters: {'patrimonio': patrimonioId},
    );

    return _converterLista(dados);
  }

  List<Movimentacao> _converterLista(dynamic dados) {
    final List<dynamic> lista;

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
        .map<Movimentacao>(
          (item) => Movimentacao.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}
