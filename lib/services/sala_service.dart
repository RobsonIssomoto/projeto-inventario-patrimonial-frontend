import 'package:projeto_inventario_patrimonial_frontend/data/network/api_requester.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/sala.dart';

class SalaService {
  final ApiRequester _requester;

  SalaService({ApiRequester? requester})
    : _requester = requester ?? ApiRequester();

  Future<List<Sala>> listarSalas() async {
    final dados = await _requester.get('/salas');

    return _converterLista(dados);
  }

  Future<List<Sala>> listarSalasDaSecretaria(String secretariaId) async {
    final dados = await _requester.get(
      '/salas',
      queryParameters: {'secretaria': secretariaId},
    );
    return _converterLista(dados);
  }

  List<Sala> _converterLista(dynamic dados) {
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
        .map<Sala>((item) => Sala.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
