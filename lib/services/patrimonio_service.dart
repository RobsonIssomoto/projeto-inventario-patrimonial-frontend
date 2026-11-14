import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';
import 'package:projeto_inventario_patrimonial_frontend/data/network/api_requester.dart';

class PatrimonioService {
  final ApiRequester _requester;

  PatrimonioService({ApiRequester? requester})
    : _requester = requester ?? ApiRequester();

  Future<List<Patrimonio>> listarPatrimonios() async {
    final dados = await _requester.get('/patrimonios');

    return _converterLista(dados);
  }

  Future<List<Patrimonio>> listarPatrimoniosDaSala(String salaId) async {
    final dados = await _requester.get(
      '/patrimonios',
      queryParameters: {'sala': salaId},
    );
    return _converterLista(dados);
  }

  Future<void> atualizarPatrimonio({
    required String id,
    required String status,
    required String estadoConservacao,
    required String observacoes,
    String? salaId,
  }) async {
    final dados = {
      'status': status,
      'estadoConservacao': estadoConservacao,
      'observacoes': observacoes,
    };

    if (salaId != null) {
      dados['sala'] = salaId;
    }

    await _requester.patch('/patrimonios/$id', dados: dados);
  }

  List<Patrimonio> _converterLista(dynamic dados) {
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
        .map<Patrimonio>(
          (item) => Patrimonio.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}
